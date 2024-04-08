import glob
import os

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext
from tqdm import tqdm


files = glob.glob("./data/editions/*.xml")
tag_blacklist = ["{http://www.tei-c.org/ns/1.0}abbr"]

COLLECTION_NAME = "tillich-briefe"


try:
    client.collections[COLLECTION_NAME].delete()
except ObjectNotFound:
    pass

current_schema = {
    "name": COLLECTION_NAME,
    "fields": [
        {"name": "id", "type": "string"},
        {"name": "rec_id", "type": "string"},
        {"name": "title", "type": "string"},
        {"name": "full_text", "type": "string"},
        {
            "name": "year",
            "type": "int32",
            "optional": True,
            "facet": True,
        },
        {"name": "persons", "type": "string[]", "facet": True, "optional": True},
        {"name": "sender", "type": "string[]", "facet": True, "optional": True},
        {"name": "receiver", "type": "string[]", "facet": True, "optional": True},
        {"name": "places", "type": "string[]", "facet": True, "optional": True},
        {"name": "orgs", "type": "string[]", "facet": True, "optional": True},
    ],
}

client.collections.create(current_schema)

records = []
cfts_records = []
for x in tqdm(files, total=len(files)):
    cfts_record = {
        "project": COLLECTION_NAME,
    }
    record = {}

    doc = TeiReader(x)
    try:
        body = doc.any_xpath(".//tei:body")[0]
    except IndexError:
        continue
    record["id"] = os.path.split(x)[-1].replace(".xml", "")
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = f"https://tillich-briefe.acdh.oeaw.ac.at/{record['id']}.html"
    record["rec_id"] = os.path.split(x)[-1]
    cfts_record["rec_id"] = record["rec_id"]
    record["title"] = " ".join(
        " ".join(
            doc.any_xpath('.//tei:titleStmt/tei:title[1]/text()')
        ).split()
    )
    cfts_record["title"] = record["title"]
    try:
        date_str = doc.any_xpath("//tei:correspAction[@type='sent']/@when")[0]
    except IndexError:
        date_str = "1000"

    try:
        record["year"] = int(date_str[:4])
        cfts_record["year"] = int(date_str[:4])
    except ValueError:
        pass
    record["sender"] = []
    try:
        sender = doc.any_xpath('.//tei:correspAction[@type="sent"]/tei:persName/text()')[
            0
        ]
    except:
        sender = None
    record["sender"].append(sender)
    record["receiver"] = []
    try:
        receiver = doc.any_xpath(
            './/tei:correspAction[@type="received"]/tei:persName/text()'
        )[0]
    except:
        receiver = None
    if receiver:
        record["receiver"].append(receiver)

    cfts_record["persons"] = record["sender"]
    record["places"] = []
    try:
        place = doc.any_xpath(
            './/tei:correspAction[@type="sent"]/tei:placeName/text()'
        )[0]
    except:
        place = None
    if place:
        record["places"].append(place)
        cfts_record["places"] = record["places"]
    record["full_text"] = extract_fulltext(body, tag_blacklist=tag_blacklist)
    cfts_record["full_text"] = record["full_text"]
    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections[COLLECTION_NAME].documents.import_(records)
print(make_index)
print(f"done with indexing {COLLECTION_NAME}")

make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
print(make_index)
print(f"done with cfts-index {COLLECTION_NAME}")
