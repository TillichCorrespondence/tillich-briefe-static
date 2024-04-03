# Purpose: Find all refrences in the TEI files and add them in the <back> tag of the file

import glob
import os
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from collections import defaultdict
from tqdm import tqdm

fileDir = "./data/editions_raw/"
files = glob.glob("./data/editions_raw/*.xml")
indicesDir = "./data/indices/"
outputDir = "./data/editions/"

#Delete output dir if it exists
if os.path.exists(outputDir):
    for file in os.listdir(outputDir):
        os.remove(outputDir + file)
else:
    os.makedirs(outputDir)
    
for x in tqdm(sorted(files), total=len(files)):
    try:
        doc = TeiReader(x)
    except Exception as e:
        print(f"Skipping invalid XML from URL: {x}")
        continue
    #Add back tag inside of the text tag
    back = ET.Element('{http://www.tei-c.org/ns/1.0}back')

    
    #Add lists inside of the back tag
    listPerson = ET.Element('{http://www.tei-c.org/ns/1.0}listPerson')
    back.append(listPerson)
    listBibl = ET.Element('{http://www.tei-c.org/ns/1.0}listBibl')
    back.append(listBibl)
    listPlace = ET.Element('{http://www.tei-c.org/ns/1.0}listPlace')
    back.append(listPlace)
    listLetter = ET.Element('{http://www.tei-c.org/ns/1.0}listLetter')
    back.append(listLetter)

    for entity in doc.any_xpath('.//tei:body//tei:rs'):
        #if the type is a person add it to the <back><listPerson> tag
        if not 'type' in entity.attrib:
            print(f"Skipping invalid rs tag in file: {x}")
            continue
        if entity.attrib['type'] == "person":
            #check if the person is already in the list
            if not any(person.text == entity.text for person in listPerson):
                person = ET.Element('{http://www.tei-c.org/ns/1.0}person')
                reference = ET.Element('{http://www.tei-c.org/ns/1.0}reference')
                reference.text = entity.text
                person.append(reference)
                if 'ref' in entity.attrib:
                    person.attrib['ref'] = entity.attrib['ref']
                    #Search in the index for the person
                    personIndex = TeiReader(indicesDir + "listperson.xml")
                    indexInformation = personIndex.any_xpath(f'.//tei:person[@xml:id="{entity.attrib["ref"].replace("#", "")}"]')
                    #append the information inside the person tag
                    for info in indexInformation:
                        for child in info:
                            person.append(child)
                else:
                    person.attrib['ref'] = "unknown"
                listPerson.append(person)
        #if the type is a place add it to the <back><listPlace> tag
        elif entity.attrib['type'] == "place":
            #check if the place is already in the list
            if not any(place.text == entity.text for place in listPlace):
                place = ET.Element('{http://www.tei-c.org/ns/1.0}place')
                reference = ET.Element('{http://www.tei-c.org/ns/1.0}reference')
                reference.text = entity.text
                place.append(reference)
                if 'ref' in entity.attrib:
                    place.attrib['ref'] = entity.attrib['ref']
                    #Search in the index for the place
                    placeIndex = TeiReader(indicesDir + "listplace.xml")
                    indexInformation = placeIndex.any_xpath(f'.//tei:place[@xml:id="{entity.attrib["ref"].replace("#", "")}"]')
                    #append the information inside the place tag
                    for info in indexInformation:
                        for child in info:
                            place.append(child)
                else:
                    place.attrib['ref'] = "unknown"
                listPlace.append(place)
        #if the type is a bibl add it to the <back><listBibl> tag
        elif entity.attrib['type'] == "work":
            #check if the bibl is already in the list
            if not any(bibl.text == entity.text for bibl in listBibl):
                bibl = ET.Element('{http://www.tei-c.org/ns/1.0}bibl')
                reference = ET.Element('{http://www.tei-c.org/ns/1.0}reference')
                if 'ref' in entity.attrib:
                    bibl.attrib['ref'] = entity.attrib['ref']
                    #Search in the index for the bibl
                    biblIndex = TeiReader(indicesDir + "listbibl.xml")
                    indexInformation = biblIndex.any_xpath(f'.//tei:bibl[@xml:id="{entity.attrib["ref"].replace("#", "")}"]')
                    bibl.text = indexInformation[0].text
                else:
                    bibl.attrib['ref'] = "unknown"
                listBibl.append(bibl)
        #if the type is a letter add it to the <back><listLetter> tag
        elif entity.attrib['type'] == "letter":
            #check if the letter is already in the list
            if not any(letter.text == entity.text for letter in listLetter):
                letter = ET.Element('{http://www.tei-c.org/ns/1.0}letter')
                reference = ET.Element('{http://www.tei-c.org/ns/1.0}reference')
                reference.text = entity.text
                letter.append(reference)
                if "{http://www.w3.org/XML/1998/namespace}id" in entity.attrib:
                    xmlId = entity.attrib["{http://www.w3.org/XML/1998/namespace}id"]
                    letter.attrib['ref'] = xmlId
                    if os.path.exists(fileDir + xmlId + ".xml"):
                        try:
                            letterRef = TeiReader(fileDir + xmlId + ".xml")
                            title = letterRef.any_xpath('.//tei:title')[0]
                            letter.append(title)
                        except Exception as e:
                            print(f"Skipping invalid XML from URL: {fileDir + xmlId + '.xml'}")
                            continue
                else:
                    letter.attrib['ref'] = "unknown"
                listLetter.append(letter)
        else:
            print(f"Skipping invalid rs tag in file {x}:")
            print(entity.attrib['type'])
            continue
            
    doc.any_xpath('.//tei:text')[0].append(back)
    doc.tree_to_file(outputDir + os.path.split(x)[1])


print("DONE")
