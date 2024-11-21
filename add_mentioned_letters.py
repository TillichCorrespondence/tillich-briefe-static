import glob
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext, check_for_hash
from acdh_xml_pyutils.xml import NSMAP
from tqdm import tqdm


print("adding 'mentioned letters'")
files = sorted(glob.glob("./data/editions/*.xml"))
lookup = {}
print(f"creating mentions lookup for {len(files)} letters")
for x in tqdm(files, total=len(files)):
    doc = TeiReader(x)
    xml_id = doc.any_xpath("./@xml:id")[0].replace(".xml", "")
    title = extract_fulltext(doc.any_xpath(".//tei:title[1]")[0])
    lookup[xml_id] = title

print("writing mentiones back into files")
no_match = set()
for y in tqdm(files, total=len(files)):
    doc = TeiReader(y)
    back = doc.any_xpath(".//tei:back")[0]
    mentioned_letters = set(doc.any_xpath(".//tei:rs[@type='letter' and @ref]/@ref"))
    for bad in doc.any_xpath(".//tei:list[@xml:id='mentioned_letters']"):
        bad.getparent().remove(bad)

    if mentioned_letters:
        letter_list = ET.Element("{http://www.tei-c.org/ns/1.0}list")
        letter_list.attrib["{http://www.w3.org/XML/1998/namespace}id"] = "mentioned_letters"
        letter_head = ET.Element("{http://www.tei-c.org/ns/1.0}head")
        letter_head.text = "erwähnte Briefe"
        letter_list.append(letter_head)
        for x in mentioned_letters:
            letter_id = check_for_hash(x)
            try:
                item = ET.Element("{http://www.tei-c.org/ns/1.0}item")
                item.attrib["{http://www.w3.org/XML/1998/namespace}id"] = letter_id
                item.text = lookup[letter_id]
                letter_list.append(item)
            except KeyError:
                no_match.add(letter_id)
                continue
        letter_count = letter_list.xpath(".//tei:item", namespaces=NSMAP)
        if letter_count:
            back.append(letter_list)
            doc.tree_to_file(y)

print("following referenced letters do not exist")
for x in no_match:
    print(x)
