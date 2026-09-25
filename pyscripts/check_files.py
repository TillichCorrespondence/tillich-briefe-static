import glob
import os

import requests
from acdh_cidoc_pyutils import extract_begin_end
from acdh_tei_pyutils.tei import TeiReader
from acdh_xml_validator import Validator
from tqdm import tqdm

schema_files = [
    "https://raw.githubusercontent.com/TillichCorrespondence/tillich-briefe-data/refs/heads/main/odd/out/tillich-briefe.rng",
    "https://raw.githubusercontent.com/TillichCorrespondence/tillich-briefe-data/refs/heads/main/odd/out/tillich-schematron.sch",
]

for x in schema_files:
    f_name = x.split("/")[-1]
    save_path = os.path.join("html", f_name)
    response = requests.get(x, timeout=30)
    response.raise_for_status()

    with open(save_path, "wb") as f:
        f.write(response.content)


validator = Validator(
    path_to_rng=os.path.join("html", "tillich-briefe.rng"), verbose=False
)

print("check if all files a well formed")

files = glob.glob("./data/*/*xml")

faulty = []
for x in tqdm(files):
    try:
        doc = TeiReader(x)
    except Exception as e:  # noqa
        mgs = f"failed to process {x} due to {e}"
        faulty.append(mgs)
        os.remove(x)


files = glob.glob("./data/editions/*.xml")
for x in tqdm(files):
    valid = validator.validate_against_rng(x)
    if not valid:
        print(f"deleting {x} because it is not valid")
        faulty.append(f"{x} not valid")
        os.remove(x)

if faulty:
    for x in faulty:
        print(x)
else:
    print("no errors, god job!")


LT_1934 = os.environ.get("LT_1934")

if LT_1934:
    print("deleting all files from after 1933")
    files = glob.glob("./data/editions/*.xml")
    for x in files:
        doc = TeiReader(x)
        try:
            date_node = doc.any_xpath(".//tei:correspAction/tei:date[@when]")[0]
            date = extract_begin_end(date_node)[0]
        except IndexError:
            date = "2000"
            print(x)
        try:
            year = int(date[:4])
        except TypeError:
            year = 2000
        if year > 1933:
            os.remove(x)
