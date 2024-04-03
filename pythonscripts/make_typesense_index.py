import glob
import os
import sys

if '--prod' not in sys.argv:
    import set_local_typesense_env
    set_local_typesense_env.setConfig()
else:
    import set_typesense_env
    set_typesense_env.setConfig()

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')

try:
    client.collections['tillich-briefe'].delete()
except ObjectNotFound:
    pass

current_schema = {
    'name': 'tillich-briefe',
    'fields': [
        {
            'name': 'id',
            'type': 'string'
        },
        {
            'name': 'rec_id',
            'type': 'string'
        },
        {
            'name': 'title',
            'type': 'string'
        },
        {
            'name': 'full_text',
            'type': 'string'
        },
        {
            'name': 'year',
            'type': 'int32',
            'optional': True,
            'facet': True,
        },
        {
            'name': 'persons',
            'type': 'string[]',
            'facet': True,
            'optional': True
        },
        {
            'name': 'places',
            'type': 'string[]',
            'facet': True,
            'optional': True
        },
        {
            'name': 'works',
            'type': 'string[]',
            'facet': True,
            'optional': True
        },
    ]
}

client.collections.create(current_schema)

records = []
cfts_records = []
for x in tqdm(files, total=len(files)):
    cfts_record = {
        'project': 'tillich-briefe',
    }
    record = {}
    try:
        doc = TeiReader(x)
        body = doc.any_xpath('.//tei:body')[0]
    except Exception as e:
        print('Skipping invalid XML from URL:', x)
        continue
        
    record['id'] = os.path.split(x)[-1].replace('.xml', '')
    cfts_record['id'] = record['id']
    cfts_record['resolver'] = f"http://127.0.0.1:5500/html/{record['id']}.html"
    record['rec_id'] = os.path.split(x)[-1]
    cfts_record['rec_id'] = record['rec_id']
    record['title'] = " ".join(" ".join(doc.any_xpath('.//tei:titleStmt/tei:title/text()')).split())
    cfts_record['title'] = record['title']
    try:
        date_str = doc.any_xpath("//tei:correspAction[@type='sent']/tei:date/@when")[0]
    except IndexError:
        date_str = "1000"

    try:
        record['year'] = int(date_str[:4])
        cfts_record['year'] = int(date_str[:4])
    except ValueError:
        pass
    record['persons'] = [
        " ".join(" ".join(x.xpath('.//text()')).split()) for x in doc.any_xpath('.//tei:back//tei:listPerson//tei:person//tei:persName')
    ]
    cfts_record['persons'] = record['persons']
    record['places'] = [
        " ".join(" ".join(x.xpath('.//text()')).split()) for x in doc.any_xpath('.//tei:back//tei:listPlace//tei:place//tei:placeName')
    ]
    cfts_record['places'] = record['places']
    record['works'] = [
        " ".join(" ".join(x.xpath('.//text()')).split()) for x in doc.any_xpath('.//tei:back//tei:listBibl//tei:bibl')
    ]
    cfts_record['works'] = record['works']
    record['full_text'] = " ".join(''.join(body.itertext()).split())
    cfts_record['full_text'] = record['full_text']
    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections['tillich-briefe'].documents.import_(records)
print(make_index)
print('done with indexing tillich-briefe')

""" make_index = CFTS_COLLECTION.documents.import_(cfts_records, {'action': 'upsert'})
print(make_index)
print('done with cfts-index tillich-briefe') """