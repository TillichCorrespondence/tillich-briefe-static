import glob
from acdh_tei_pyutils.tei import TeiReader
import lxml.etree as ET
import pandas as pd
from tqdm import tqdm

files = sorted(glob.glob("./data/editions/*.xml"))
main_person_id = "#tillich_person_id__1928"


def get_date(doc):
    try:
        date = doc.any_xpath(".//tei:correspDesc//tei:date[@notBefore]/@notBefore")[0]
    except IndexError:
        try:
            date = doc.any_xpath(".//tei:correspDesc//tei:date[@when]/@when")[0]
        except IndexError:
            try:
                date = doc.any_xpath(".//tei:correspDesc//tei:date[@from]/@from")[0]
            except IndexError:
                date = "Ohne Datum"
    return date


broken = []
items = []
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
    corresp_names = " und ".join(
        [
            (x.text if x.text is not None else "?")
            for x in doc.any_xpath(".//tei:correspAction/tei:persName")
            if x.attrib["ref"] != main_person_id
        ]
    )
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
df = pd.DataFrame(items)
df["gen_prev"] = df["id"].shift(1)
df["gen_next"] = df["id"].shift(-1)
df["gen_prev_title"] = df["title"].shift(1)
df["gen_next_title"] = df["title"].shift(-1)

df.to_csv("tmp.csv", index=False)

for i, ndf in df.groupby("corresp_id"):
    sorted_df = ndf.sort_values("id")
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
        if x["prev"] is not None:
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
        if x["next"] is not None:
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
        if x["gen_prev"] is not None:
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
        if x["gen_next"] is not None:
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
