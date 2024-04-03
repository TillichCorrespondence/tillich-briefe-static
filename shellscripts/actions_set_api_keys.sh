#This script gets the github actions secrets and env variables and sets them in the set_typesense_env.py script
# This script is intended to be run in the github actions pipeline

# Get the secrets and env variables
ts_api_key=$TS_API_KEY
ts_search_key=$TS_SEARCH_KEY
ts_host=$TS_HOST
ts_port=$TS_PORT
ts_protocol=$TS_PROTOCOL

sed -i "s/ts-api-key/$ts_api_key/g" pythonscripts/set_typesense_env.py
sed -i "s/ts-search-key/$ts_search_key/g" pythonscripts/set_typesense_env.py
sed -i "s/ts-host/$ts_host/g" pythonscripts/set_typesense_env.py
sed -i "s/ts-port/$ts_port/g" pythonscripts/set_typesense_env.py
sed -i "s/ts-protocol/$ts_protocol/g" pythonscripts/set_typesense_env.py

#echo updated file
cat pythonscripts/set_typesense_env.py