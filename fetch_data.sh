#!/bin/bash

REDMINE_ID="21311?format=xhtml&locale="
IMPRINT_XML=./data/imprint.xml

echo "fetching transkriptions from data_repo"
curl -LO https://github.com/TillichCorrespondence/tillich-briefe-data/archive/refs/heads/main.zip
unzip ./main
rm -rf data
mv ./tillich-briefe-data-main/data .
rm -rf ./main.zip ./tillich-briefe-data-main

echo "fetching indices from tillich-entities"
rm -rf data/indices
curl -LO https://github.com/TillichCorrespondence/tillich-entities/archive/refs/heads/main.zip
unzip main
rm main.zip
mkdir ./data/indices
mv ./tillich-entities-main/data/indices ./data
rm -rf tillich-entities-main

rm ./data/indices/listbibl.xml
wget https://raw.githubusercontent.com/TillichCorrespondence/tillich-zotero/refs/heads/main/listbibl.xml -P ./data/indices

echo "fetching imprint"
echo '<?xml version="1.0" encoding="UTF-8"?>' >> ${IMPRINT_XML}
echo "<root>" >> ${IMPRINT_XML}
echo '<div lang="de">' >> ${IMPRINT_XML}
curl https://imprint.acdh.oeaw.ac.at/${REDMINE_ID}de >> ${IMPRINT_XML}
echo "</div>"  >> ${IMPRINT_XML}
echo '<div lang="en">' >> ${IMPRINT_XML}
curl https://imprint.acdh.oeaw.ac.at/${REDMINE_ID}en >> ${IMPRINT_XML}
echo "</div>" >> ${IMPRINT_XML}
echo "</root>" >> ${IMPRINT_XML}

python check_files.py
python fixing_refs.py
python remove_lb_from_title.py
