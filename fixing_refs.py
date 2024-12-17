import glob
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash


print("makes sure all @ref in <tei:rs> start with '#', except for @type='bible'")
files = sorted(glob.glob("./data/editions/*.xml"))
for x in files:
    try:
        doc = TeiReader(x)
    except Exception as e:
        print(e)
        continue
    for y in doc.any_xpath(".//*[@ref='']"):
        y.attrib.pop("ref")
    for y in doc.any_xpath(".//tei:rs[@ref and @type]"):
        ref = y.attrib["ref"]
        type = y.attrib["type"]
        try:
            ref[0] == "#"
        except IndexError:
            print(x, ET.tostring(y))
            continue
        if type == "bible":
            y.attrib["ref"] = check_for_hash(ref)
        else:
            y.attrib["ref"] = f"#{check_for_hash(ref)}"
    for y in doc.any_xpath(".//tei:rs[@resp and @type='bible']"):
        y.attrib["ref"] = y.attrib.pop("resp")
    doc.tree_to_file(x)
