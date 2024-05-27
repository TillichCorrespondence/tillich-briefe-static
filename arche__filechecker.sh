#/bin/bash

rm -rf ${PWD}/fc_out && mkdir ${PWD}/fc_out
docker run \
  --rm \
  -v ${PWD}/fc_out:/reports \
  -v ${PWD}/to_ingest:/data \
  --entrypoint arche-filechecker \
  acdhch/arche-ingest \
  --csv --overwrite --skipWarnings /data /reports