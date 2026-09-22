import glob
import os

from acdh_cidoc_pyutils import extract_begin_end
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

print("check if all files a well formed")

files = glob.glob("./data/*/*xml")

faulty = []
for x in tqdm(files):
    try:
        doc = TeiReader(x)
    except Exception as e:
        mgs = f"failed to process {x} due to {e}"
        faulty.append(mgs)
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
