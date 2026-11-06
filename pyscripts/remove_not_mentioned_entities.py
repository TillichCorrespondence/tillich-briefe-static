import os

from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash, get_xmlid

index_files = ["listperson.xml", "listplace.xml"]

places_to_keep = set()

listperson = os.path.join("data", "indices", index_files[0])

doc = TeiReader(listperson)

for x in doc.any_xpath(".//@key"):
    places_to_keep.add(check_for_hash(x))

for x in index_files:
    file = os.path.join("data", "indices", x)
    doc = TeiReader(file)
    for bad in doc.any_xpath("//tei:person[not(.//tei:note[@type='mentions'])]"):
        bad.getparent().remove(bad)
    for bad in doc.any_xpath("//tei:place[not(.//tei:note[@type='mentions'])]"):
        xml_id = get_xmlid(bad)
        if xml_id in places_to_keep:
            pass
        else:
            bad.getparent().remove(bad)
    doc.tree_to_file(file)
