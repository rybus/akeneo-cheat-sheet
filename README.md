# Akeneo Cheat Sheet

## SSH

```bash
# check access to the PIM enterprise repository
ssh git@distribution.akeneo.com -p 443

# add your private k
```
## Docker

```bash
docker-compose up -d       # starts containers, pulls them if necesary
docker-compose ps          # lists running containers
docker-compose stop        # stops running containers
docker-compose restart fpm # restarts the container named fpm
```

## Akeneo x Docker

```bash
bin/docker/pim-dependencies.sh # installs dependencies (uses composer)
bin/docker/pim-initialize.sh   # installs the PIM
bin/docker/pim-front.sh        # regenerates and deploy all front-end assets
```

## Elasticsearch

```bash
curl -XGET 'http://localhost:9200/_cat/indices?v' # list indexes
```

### Available indices (as of 3.0.22)
- `akeneo_pim_published_product_and_product_model`
- `akeneo_pim_product_model`
- `akeneo_referenceentity_record`
- `akeneo_pim_published_product`
- `akeneo_pim_product`
- `akeneo_pim_product_proposal`
- `akeneo_pim_product_and_product_model`

```bash
# display the mapping for a given index
curl -XGET 'http://localhost:9200/akeneo_pim_product/?pretty'

# check document for product with id X
curl -XGET 'http://localhost:9200/akeneo_pim_product/pim_catalog_product/X?pretty' 
```

Use this [Postman collection](postman/pim-es-collection.json) and its [environment](postman/pim-es-environment.json) for other useful requests. Use them only for debugging purposes, never write in ES manually.

### Reset all indices and re-index the PIM

Usage: `elastic.sh [use-docker]`
Add `use-docker` to execute commands inside containers.

```bash
#!/usr/bin/env bash

DOCKER=${1:-"na"}

if [ "${DOCKER}" == "use-docker" ]; then
    PREFIX="docker-compose exec fpm bin/console "
else
    PREFIX="bin/console "
fi

${PREFIX} akeneo:elasticsearch:reset-indexes -n --env=prod
${PREFIX} pim:product:index --env=prod  --all
${PREFIX} pim:product-model:index --env=prod  --all
${PREFIX} pimee:product-proposal:index
${PREFIX} fpm bin/console pimee:published-product:index  --env=prod
```
