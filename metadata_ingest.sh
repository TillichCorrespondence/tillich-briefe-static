#/bin/bash

composer require -W acdh-oeaw/arche-ingest:^1.4.6
vendor/bin/arche-import-metadata html/arche.ttl https://arche-dev.acdh-dev.oeaw.ac.at/api pandorfer csae8092

