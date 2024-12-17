import glob
import os
import lxml.etree as ET
from collections import defaultdict
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import normalize_string, extract_fulltext

files = sorted(glob.glob("./data/editions/*.xml"))
d = defaultdict(list)


for x in files:
    doc_id = os.path.split(x)[-1]
    doc = TeiReader(x)
    for y in doc.any_xpath(".//tei:rs[@type='bible' and @ref]"):
        ref = y.attrib["ref"].replace(",", "").replace(" ", "").replace("-", "").lower()
        try:
            text = normalize_string(extract_fulltext(y))
        except AttributeError:
            text = y.attrib["ref"]
        item = {
            "id": ref,
            "bible": y.attrib["ref"],
            "text": text,
            "doc": doc_id
        }
        d[ref].append(item)

tei_dummy = """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:base="https://tillich-briefe.acdh.oeaw.ac.at" xml:id="listbible.xml">
    <teiHeader>
        <fileDesc>
            <titleStmt>
                <title>Zitierte Bibelstellen</title>
            </titleStmt>
            <editionStmt>
                <edition>
                <title type="editionstitel">
                    Edition der Korrespondenz von Paul Tillich 1887-1933
                </title>
                </edition>
            </editionStmt>
            <publicationStmt>
                <publisher>
                <name>
                    Institut für Systematische Theologie und Religionswissenschaft
                </name>
                <address>
                    <street>Schenkenstraße 8-10</street>
                    <postCode>1010</postCode>
                    <placeName ref="#tillich_place_id__470">Wien</placeName>
                </address>
                </publisher>
                <availability>
                <licence target="http://creativecommons.org/licenses/by/4.0/">
                    Creative Commons Attribution 4.0 International (CC BY 4.0)
                </licence>
                </availability>
            </publicationStmt>
            <sourceDesc>
                <p>Automatisch generiert mit "make_corresp_toc.py"</p>
            </sourceDesc>
        </fileDesc>
    </teiHeader>
    <text>
        <body>
            <listBibl xml:id="listBible"/>
        </body>
    </text>
</TEI>
"""  # noqa:

doc = TeiReader(tei_dummy)
list_bible = doc.any_xpath(".//tei:body/tei:listBibl")[0]
for key, value in d.items():
    biblnode = ET.Element("{http://www.tei-c.org/ns/1.0}bibl")
    biblnode.attrib["n"] = f"{key}"
    list_bible.append(biblnode)
    titlenode = ET.Element("{http://www.tei-c.org/ns/1.0}title")
    titlenode.text = value[0]["bible"]
    biblnode.append(titlenode)
    notgrpnode = ET.Element("{http://www.tei-c.org/ns/1.0}noteGrp")
    biblnode.append(notgrpnode)
    for y in value:
        notenode = ET.Element("{http://www.tei-c.org/ns/1.0}note")
        notenode.attrib["type"] = "mentiones"
        notenode.attrib["target"] = y["doc"]
        notenode.text = y["text"]
        notgrpnode.append(notenode)


doc.tree_to_file("./data/indices/listbible.xml")
