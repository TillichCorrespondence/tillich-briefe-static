#/bin/bash

echo "delete ${TOPCOLID} from ${ARCHE}"
docker run --rm \
  --entrypoint arche-delete-resource \
  acdhch/arche-ingest \
  ${TOPCOLID} ${ARCHE} ${ARCHE_USER} ${ARCHE_PASSWORD} --recursively
