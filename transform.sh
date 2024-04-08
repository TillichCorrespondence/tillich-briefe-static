#!/bin/bash

echo "adding xml:id and next/prev attributes into root element of tei-docs"
add-attributes -g "./data/editions/*.xml" -b "https://tillich-briefe.acdh.oeaw.ac.at/tillich-briefe"
python check_files.py


echo "denormalizing indices" 
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml"

python remove_notegrp_from_back.py
# echo "add back"
# python3 pythonscripts/add_back.py

# echo "add mentions"
# python3 pythonscripts/add_mentions.py

# echo set typesense config
# cp typesense-config-prod.js html/js/typesense-config.js

echo "add Corresp Context"
python3 pythonscripts/add_corresp_context.py

# echo "build ft-index"
# python3 pythonscripts/make_typesense_index.py --prod

# echo "create app"
# ant