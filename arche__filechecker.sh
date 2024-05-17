#/bin/bash

python3 -m pip install --user cvdupdate && cvd update

rm -rf fc_out && mkdir fc_out
docker run \
  --rm \
  -v ${PWD}/fc_out:/reports \
  -v ${PWD}/to_ingest:/data \
  -v ~/.cvdupdate/database/:/var/lib/clamav \
  acdhch/arche-filechecker