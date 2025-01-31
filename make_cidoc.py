import glob
from rdflib import Graph

from acdh_cidoc_pyutils import teidoc_as_f24_publication_expression


files = glob.glob("./data/editions/*.xml")

g = Graph()
for x in files[:4]:
    g += teidoc_as_f24_publication_expression(
        x, "https://tillich-briefe.acdh.oeaw.ac.at", add_mentions=False
    )[1]
g.serialize("html/cidoc.nt", format="nt", encoding="utf-8")
