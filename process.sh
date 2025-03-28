#!/bin/bash

echo "adding xml:id and next/prev attributes into root element of tei-docs"
add-attributes -g "./data/editions/*.xml" -b "https://tillich-briefe.acdh.oeaw.ac.at"

echo "denormalizing indices" 
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml"

python remove_notegrp_from_back.py

echo "add Corresp Context"
python add_correspContext.py

echo "make corresp_toc.xml"
python make_corresp_toc.py

echo "make bible_toc.xml"
python make_bible_toc.py

echo "adding mentioned letters"
python add_mentioned_letters.py

echo "make calendar data"
python make_calendar_data.py

echo "creating some cidoc"
python make_cidoc.py

echo "creating qlever words- and docsfile"
python make_qlever_text.py