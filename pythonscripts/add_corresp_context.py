# Purpose: Find all refrences in the TEI files and add them in the <back> tag of the file

import glob
import os
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from collections import defaultdict
from tqdm import tqdm

files = glob.glob("./data/editions/*.xml")
outputDir = "./data/editions/"

def sortByName(x):
    return x.split("/")[-1].split(".")[0][1:]

sortedFiles = sorted(files, key=sortByName)
    
for x in tqdm(sortedFiles, total=len(sortedFiles)):
    try:
        doc = TeiReader(x)
    except Exception as e:
        print(f"Skipping invalid XML from URL: {x}")
        continue
    #Add correspContext
    correspContext = ET.Element('{http://www.tei-c.org/ns/1.0}correspContext')
    currentXmlId = os.path.split(x)[1].replace(".xml", "")
      
    prevLetterColl = ET.Element('{http://www.tei-c.org/ns/1.0}ref')
    nextLetterColl = ET.Element('{http://www.tei-c.org/ns/1.0}ref')
    
    prevLetterColl.attrib['subtype'] = "previous_letter"
    nextLetterColl.attrib['subtype'] = "next_letter"
    
    prevLetterColl.attrib['type'] = "withinCollection"
    nextLetterColl.attrib['type'] = "withinCollection"
    
    #Get previous letter from the file list
    index = sortedFiles.index(x)
    if index > 0:
        prevLetterColl.attrib['target'] = os.path.split(sortedFiles[index-1])[1].replace(".xml", "")
        prevLetterColl.text = TeiReader(sortedFiles[index-1]).any_xpath('.//tei:title')[0].text
        correspContext.append(prevLetterColl)
        
    #Get next letter from the file list
    if index < len(sortedFiles)-1:
        nextLetterColl.attrib['target'] = os.path.split(sortedFiles[index+1])[1].replace(".xml", "")
        nextLetterColl.text = TeiReader(sortedFiles[index+1]).any_xpath('.//tei:title')[0].text
        correspContext.append(nextLetterColl)
        
    #Get previous letter from the correspondence, by searching over all previous letters for 
    if index > 0:
        for i in range(index-1, -1, -1):
            prevDoc = TeiReader(sortedFiles[i])
            if prevDoc.any_xpath('.//tei:rs[@xml:id="' + currentXmlId + '"]'):
                prevLetterCorr = ET.Element('{http://www.tei-c.org/ns/1.0}ref')
                prevLetterCorr.attrib['subtype'] = "previous_letter"
                prevLetterCorr.attrib['type'] = "withinCorrespondence"
                prevLetterCorr.attrib['target'] = os.path.split(sortedFiles[i])[1].replace(".xml", "")
                prevLetterCorr.text = TeiReader(sortedFiles[i]).any_xpath('.//tei:title')[0].text
                correspContext.append(prevLetterCorr)
            
    #Get next letter from the correspondence, by searching over all next letters for
    if index < len(sortedFiles)-1:
        for i in range(index+1, len(sortedFiles)):
            nextDoc = TeiReader(sortedFiles[i])
            if nextDoc.any_xpath('.//tei:rs[@xml:id="' + currentXmlId + '"]'):
                nextLetterCorr = ET.Element('{http://www.tei-c.org/ns/1.0}ref')
                nextLetterCorr.attrib['subtype'] = "next_letter"
                nextLetterCorr.attrib['type'] = "withinCorrespondence"
                nextLetterCorr.attrib['target'] = os.path.split(sortedFiles[i])[1].replace(".xml", "")
                nextLetterCorr.text = TeiReader(sortedFiles[i]).any_xpath('.//tei:title')[0].text
                correspContext.append(nextLetterCorr)
                
    doc.any_xpath('.//tei:correspDesc')[0].append(correspContext)
    doc.tree_to_file(outputDir + os.path.split(x)[1])


print("DONE")