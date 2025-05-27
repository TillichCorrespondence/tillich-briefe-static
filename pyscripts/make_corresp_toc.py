import pandas as pd
import lxml.etree as ET

from acdh_tei_pyutils.tei import TeiReader

df = pd.read_csv("tmp.csv")

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


for corresp_id, ndf in df.groupby("corresp_id"):
   my_list = ET.SubElement(body, "list")
   my_list.attrib["{http://www.w3.org/XML/1998/namespace}id"] = corresp_id[1:]
   ET.SubElement(my_list, "head").text = f'{ndf.iloc[0]["corresp_names"]}'
   for i, row in ndf.iterrows():
      item = ET.SubElement(my_list, "item")
      title = ET.SubElement(item, "title").text = row["title"]
      date = ET.SubElement(item, "date").text = row["date"]
      ptr = ET.SubElement(item, "ptr")
      ptr.attrib["target"] = f'{row["id"].split("/")[-1]}'

doc.tree_to_file("./data/indices/corresp_toc.xml")
