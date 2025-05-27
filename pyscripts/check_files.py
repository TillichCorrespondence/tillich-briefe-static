import glob
import os
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
