import glob
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext
from tqdm import tqdm

print("removes lb from title")

files = glob.glob("./data/editions/*xml")

faulty = []
for x in tqdm(files):
    doc = TeiReader(x)
    title_node = doc.any_xpath(".//tei:titleStmt/tei:title[1]")[0]
    title_text = extract_fulltext(title_node)
    for bad in doc.any_xpath(".//tei:titleStmt/tei:title[1]/tei:lb"):
        bad.getparent().remove(bad)
    title_node.text = title_text
    doc.tree_to_file(x)
