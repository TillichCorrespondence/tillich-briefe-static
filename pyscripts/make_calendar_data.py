import glob
import os
import json
from datetime import datetime

from acdh_cidoc_pyutils import extract_begin_end
from acdh_tei_pyutils.tei import TeiReader
from dateutil.parser import parse

files = glob.glob("./data/editions/*xml")

out_dir = os.path.join("html", "js-data")
out_file = os.path.join(out_dir, "calendarData.json")
os.makedirs(out_dir, exist_ok=True)

reference_date = datetime.strptime("1940-01-01", "%Y-%m-%d")

data = []
for x in files:
    doc = TeiReader(x)
    link = os.path.split(x)[-1].replace(".xml", ".html")
    start, end = extract_begin_end(doc.any_xpath(".//tei:correspAction[1]/tei:date[1]")[0])
    if start and end and parse(start, default=None) < reference_date:
        item = {
            "date": f"{parse(start, default=None, ignoretz=True)}".split(" ")[0],  # ugly way to remove time
            "label": doc.any_xpath(".//tei:title[1]")[0].text,
            "link": link,
            "kind": "Brief"
        }
        data.append(item)

with open(out_file, "w", encoding="utf-8") as fp:
    json.dump(data, fp, ensure_ascii=False, indent=2)

print(f"saving calendar data as {out_file}")
