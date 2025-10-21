import glob
import re
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext
from acdh_cidoc_pyutils import extract_begin_end
from tqdm import tqdm

print("removes lb from titles and adds sort date")


def normalize_date(date_str):
    """
    Normalize a date string to YYYY-MM-DD format.
    - If only YYYY is given → add '-01-01'
    - If YYYY-MM is given → add '-01'
    - If YYYY-MM-DD is complete → return as is
    """
    date_str = str(date_str).strip()

    if re.fullmatch(r"\d{4}-\d{2}-\d{2}", date_str):
        return date_str

    elif re.fullmatch(r"\d{4}-\d{2}", date_str):
        return f"{date_str}-01"

    elif re.fullmatch(r"\d{4}", date_str):
        return f"{date_str}-01-01"

    else:
        raise ValueError(f"Invalid date format: {date_str}")


files = glob.glob("./data/editions/*xml")

faulty = []
for x in tqdm(files):
    doc = TeiReader(x)
    title_node = doc.any_xpath(".//tei:titleStmt/tei:title[1]")[0]
    title_text = extract_fulltext(title_node)
    for bad in doc.any_xpath(".//tei:titleStmt/tei:title[1]/tei:lb"):
        bad.getparent().remove(bad)
    title_node.text = title_text
    for bad in doc.any_xpath(".//tei:creation[./tei:date[@type='sort']]"):
        bad.getparent().remove(bad)
    profile_desc = doc.any_xpath(".//tei:profileDesc")[0]
    creation = ET.SubElement(profile_desc, "{http://www.tei-c.org/ns/1.0}creation")
    date_elem = ET.SubElement(creation, "{http://www.tei-c.org/ns/1.0}date")
    date_elem.attrib["type"] = "sort"
    try:
        date = doc.any_xpath(".//tei:correspAction[@type='sent']/tei:date")[0]
    except IndexError:
        action_node = doc.any_xpath(".//tei:correspAction[@type='sent']")[0]
        date = ET.SubElement(action_node, "{http://www.tei-c.org/ns/1.0}date")
        date.attrib["when"] = "2000-01-01"
        print(f"NO DATE!!!! for {x}")
    try:
        norm_date = normalize_date(extract_begin_end(date)[0])
    except ValueError:
        print(x)
        norm_date = "2000"
    date_elem.attrib["when"] = norm_date
    doc.tree_to_file(x)
