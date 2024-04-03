#!/bin/bash
# This script transform the xmls from the data folder to html files. Intended for production use.
echo "add back"
python3 pythonscripts/add_back.py

echo "add mentions"
python3 pythonscripts/add_mentions.py

echo set typesense config
cp typesense-config-prod.js html/js/typesense-config.js

echo "add Corresp Context"
python3 pythonscripts/add_corresp_context.py

echo "build ft-index"
python3 pythonscripts/make_typesense_index.py --prod

echo "create app"
ant