#!/bin/bash

echo "adding xml:id and next/prev attributes into root element of tei-docs"
add-attributes -g "./data/editions/*.xml" -b "https://tillich-briefe.acdh.oeaw.ac.at"

echo "denormalizing indices" 
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml"

python pyscripts/remove_notegrp_from_back.py

echo "add Corresp Context"
python pyscripts/add_correspContext.py

echo "make corresp_toc.xml"
python pyscripts/make_corresp_toc.py

echo "make bible_toc.xml"
python pyscripts/make_bible_toc.py

echo "adding mentioned letters"
python pyscripts/add_mentioned_letters.py

echo "make calendar data"
python pyscripts/make_calendar_data.py

echo "creating some cidoc"
python pyscripts/make_cidoc.py

echo "creating qlever words- and docsfile"
python pyscripts/make_qlever_text.py