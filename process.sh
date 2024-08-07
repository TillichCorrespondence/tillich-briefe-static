#!/bin/bash

echo "adding xml:id and next/prev attributes into root element of tei-docs"
add-attributes -g "./data/editions/*.xml" -b "https://tillich-briefe.acdh.oeaw.ac.at"
python3 check_files.py

echo "denormalizing indices" 
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml"

python3 remove_notegrp_from_back.py

echo "add Corresp Context"
python3 add_correspContext.py

echo "make corresp_toc.xml"
python3 make_corresp_toc.py
