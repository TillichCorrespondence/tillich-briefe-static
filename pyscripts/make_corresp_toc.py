import pandas as pd
import lxml.etree as ET
import json
from acdh_tei_pyutils.tei import TeiReader



pdf = pd.read_csv("tmp_persons.csv", parse_dates=["date"])

tei_dummy = """
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:base="https://tillich-briefe.acdh.oeaw.ac.at" xml:id="corresp_toc.xml">
   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title>Verzeichnis der Korrespondenzen</title>
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
         <list xml:id="asdf">
            <head></head>
            <item>
               <title></title>
               <date></date>
               <ptr/>
            </item>
         </list>
      </body>
   </text>
</TEI>
"""  # noqa:

doc = TeiReader(tei_dummy)
body = doc.any_xpath(".//tei:body")[0]


for ref, ndf in pdf.groupby("person_ref"):
    my_list = ET.SubElement(body, "list")
    my_list.attrib["{http://www.w3.org/XML/1998/namespace}id"] = f"correspondence__{ref.lstrip('#')}"
    # only this person's own name variants, oldest first (ndf is date-sorted)
    ET.SubElement(my_list, "head").text = " / ".join(ndf["person_name"].drop_duplicates())

    for _, row in ndf.iterrows():
        item = ET.SubElement(my_list, "item")
        ET.SubElement(item, "title").text = row["title"]
        ET.SubElement(item, "date").text = (
            row["date"].strftime("%Y-%m-%d") if pd.notna(row["date"]) else "9999"
        )
        ET.SubElement(item, "ptr").attrib["target"] = row["id"].split("/")[-1]
        ET.SubElement(item, "note", type="direction").text = row["direction"]

        others = row["additional_correspondents"]
        if pd.notna(others):  # an empty cell is read by pandas as NaN
            ET.SubElement(item, "note", type="additional_correspondents").text = others

doc.tree_to_file("./data/indices/listcorresp.xml")