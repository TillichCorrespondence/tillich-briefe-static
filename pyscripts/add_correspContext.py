import glob
import os
from acdh_tei_pyutils.tei import TeiReader
import lxml.etree as ET
import pandas as pd
import re
from tqdm import tqdm

files = sorted(glob.glob("./data/editions/*.xml"))
main_person_id = "#tillich_person_id__1928"
REF_PATTERN = re.compile(r"#tillich_person_id__\d+")
skipped_refs = set()


def get_date(doc):
    date = doc.any_xpath(".//tei:date[@type='sort']/@when")[0]
    return date


broken = []
items = []
person_items = []
print(f"fetching data from {len(files)} files")
for x in tqdm(files, total=len(files)):
    try:
        doc = TeiReader(x)
    except Exception as e:
        broken.append([e, x])
        continue
    corresp_id = "_".join(
        sorted(
            [
                x
                for x in doc.any_xpath(".//tei:correspAction/tei:persName/@ref")
                if x != main_person_id
            ]
        )
    )
    try:
        corresp_names = " und ".join(
            [
                (x.text if x.text is not None else "?")
                for x in doc.any_xpath(".//tei:correspAction/tei:persName")
                if x.attrib["ref"] != main_person_id
            ]
        )
    except KeyError:
        broken.append(x)
        continue
    item = {
        "id": x,
        "corresp_id": f"#corresp__{corresp_id.replace('#', '')}",
        "corresp_names": corresp_names,
        "title": doc.any_xpath(
            ".//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[1]/text()"
        )[0],
        "date": get_date(doc),
    }
    items.append(item)

        # --- collect all correspondants for listcorrespondent.xml ---
    title = item["title"]
    date = item["date"]
    main_sent = bool(doc.any_xpath(
        f".//tei:correspAction[@type='sent']/tei:persName[@ref='{main_person_id}']"))
    main_received = bool(doc.any_xpath(
        f".//tei:correspAction[@type='received']/tei:persName[@ref='{main_person_id}']"))

    people = []  # (ref, name, role) without the main person
    for role in ("sent", "received"):
        for p in doc.any_xpath(f".//tei:correspAction[@type='{role}']/tei:persName"):
            ref = p.attrib["ref"]
            if ref == main_person_id:
                continue
            if not REF_PATTERN.fullmatch(ref):
                skipped_refs.add(ref)
                continue
            name = " ".join("".join(p.itertext()).split()) or "?"
            people.append((ref, name, role))

    for ref, name, role in people:
        # was the main person on the other side of the letter?
        if role == "sent" and main_received:
            direction = "sent_to_main"            # this person wrote to the main person
        elif role == "received" and main_sent:
            direction = "received_from_main"      # the main person wrote to this person
        elif role == "sent" and main_sent:
            direction = "cosender_with_main"      # this person and the main person wrote together
        elif role == "received" and main_received:
            direction = "corecipient_with_main"   # this person and the main person received together
        else:
            direction = "third_party"             # letter between third parties
        others = sorted({n for r, n, _ in people if r != ref})
        person_items.append({
            "id": x,
            "person_ref": ref,
            "person_name": name,
            "role": role,
            "direction": direction,
            "additional_correspondents": ", ".join(others),
            "title": title,
            "date": date,
        })

pdf = pd.DataFrame(person_items)
pdf["date"] = pd.to_datetime(pdf["date"], errors="coerce")
pdf["year"] = pdf["date"].dt.year.astype("Int64")
pdf = pdf.sort_values(["person_ref", "date", "id"]).reset_index(drop=True)
pdf.to_csv("tmp_persons.csv", index=False)


df = pd.DataFrame(items)
df["date"] = pd.to_datetime(df["date"], errors="coerce")
df = df.sort_values(["date", "id"]).reset_index(drop=True)
df["gen_prev"] = df["id"].shift(1)
df["gen_next"] = df["id"].shift(-1)
df["gen_prev_title"] = df["title"].shift(1)
df["gen_next_title"] = df["title"].shift(-1)

df.to_csv("tmp.csv", index=False)

for i, ndf in df.groupby("corresp_id"):
    sorted_df = ndf.sort_values("date")
    sorted_df["prev"] = sorted_df["id"].shift(1)
    sorted_df["next"] = sorted_df["id"].shift(-1)
    sorted_df["prev_title"] = sorted_df["title"].shift(1)
    sorted_df["next_title"] = sorted_df["title"].shift(-1)
    for j, x in tqdm(sorted_df.iterrows(), total=len(sorted_df)):
        try:
            doc = TeiReader(x["id"])
        except Exception:
            print(f"Cannot add correspContext to file: {x['id']}")
            continue
        for bad in doc.any_xpath("//tei:correspContext"):
            bad.getparent().remove(bad)

        try:
            correspDesc = doc.any_xpath("//tei:correspDesc")[0]
        except IndexError as e:
            broken.append([e, x["id"]])
            continue
        correspContext = ET.SubElement(correspDesc, "correspContext")
        ref = ET.SubElement(
            correspContext,
            "ref",
            type="belongsToCorrespondence",
            target=x["corresp_id"],
        )
        ref.text = f'Korrespondenz mit {x["corresp_names"]}'
        if pd.notna(x["prev"]):
            prevCorr = ET.SubElement(
                correspContext,
                "ref",
                subtype="previous_letter",
                type="withinCorrespondence",
                source=x["corresp_id"],
                target=x["prev"].split("/")[-1],
            )
            prevCorr.text = (
                "" if x["prev_title"] is None else x["prev_title"].split("/")[-1]
            )
        if pd.notna(x["next"]):
            nextCorr = ET.SubElement(
                correspContext,
                "ref",
                subtype="next_letter",
                type="withinCorrespondence",
                source=x["corresp_id"],
                target=x["next"].split("/")[-1],
            )
            nextCorr.text = (
                "" if x["next_title"] is None else x["next_title"].split("/")[-1]
            )
        if pd.notna(x["gen_prev"]):
            genPrevCorr = ET.SubElement(
                correspContext,
                "ref",
                subtype="previous_letter",
                type="withinCollection",
                target=x["gen_prev"].split("/")[-1],
            )
            genPrevCorr.text = (
                ""
                if x["gen_prev_title"] is None
                else x["gen_prev_title"].split("/")[-1]
            )
        if pd.notna(x["gen_next"]):
            genNextCorr = ET.SubElement(
                correspContext,
                "ref",
                subtype="next_letter",
                type="withinCollection",
                target=x["gen_next"].split("/")[-1],
            )
            genNextCorr.text = (
                ""
                if x["gen_next_title"] is None
                else x["gen_next_title"].split("/")[-1]
            )

        doc.tree_to_file(x["id"])

for i, row in df.iterrows():
    try:
        doc = TeiReader(row["id"])
    except Exception:
        print(f"Cannot add correspContext to file: {row['id']}")
        continue
    root = doc.any_xpath("/tei:TEI")[0]
    if pd.notna(row["gen_next"]):
        root.attrib["next"] = os.path.split(row["gen_next"])[-1]

    if pd.notna(row["gen_prev"]):
        root.attrib["prev"] = os.path.split(row["gen_prev"])[-1]
    doc.tree_to_file(row["id"])

print(broken)
print(skipped_refs) 