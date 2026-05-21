#!/bin/bash

echo "adding xml:id and next/prev attributes into root element of tei-docs"
uv run add-attributes -g "./data/editions/*.xml" -b "https://tillich-briefe.acdh.oeaw.ac.at"

echo "denormalizing indices" 
uv run denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml"

uv run pyscripts/remove_notegrp_from_back.py

echo "fix refs"
uv run pyscripts/fixing_refs.py

echo "add Corresp Context"
uv run pyscripts/add_correspContext.py

echo "make corresp_toc.xml"
uv run pyscripts/make_corresp_toc.py

echo "make bible_toc.xml"
uv run pyscripts/make_bible_toc.py

echo "adding mentioned letters"
uv run pyscripts/add_mentioned_letters.py

echo "adding correspondence context"
uv run pyscripts/add_correspContext.py

echo "make calendar data"
uv run pyscripts/make_calendar_data.py

# echo "creating some cidoc"
# uv run pyscripts/make_cidoc.py

# echo "creating qlever words- and docsfile"
# uv run pyscripts/make_qlever_text.py