#!/bin/bash
# This script transform the xmls from the data folder to html files. Intended for local development use.

#if [ "$(curl -s http://localhost:8108/health | jq -r .ok)" != "true" ]; then
#    echo "typesense not running, starting it"
#    sudo bash ./shellscripts/start_local_typesense_server.sh &
#    sleep 5
#fi

#check if data/editions_raw exists
if [ ! -d "data/editions_raw" ]; then
    echo "data/editions_raw does not exist, copying it"
    sudo cp -r ../dev-tillich-briefe-data/data/editions ./data/editions_raw
fi

#check if data/indices exists
if [ ! -d "data/indices" ]; then
    echo "data/indices does not exist, copying it"
    sudo cp -r ../dev-tillich-briefe-data/data/indices ./data/indices
fi

#check if data/meta exists
if [ ! -d "data/meta" ]; then
    echo "data/meta does not exist, copying it"
    sudo cp -r ../dev-tillich-briefe-data/data/meta ./data/meta
fi

echo "add back"
python3 pythonscripts/add_back.py

echo "add mentions"
python3 pythonscripts/add_mentions.py

echo "add Corresp Context"
python3 pythonscripts/add_corresp_context.py

echo "set typesense config"
cp typesense-config-dev.js html/js/typesense-config.js

#echo "build typesense index"
#python3 pythonscripts/make_typesense_index.py

echo "create app"
ant