# Akeneo Cheat Sheet

## SSH

```bash
# generate a new pair of private/public keys
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# start the agent
eval "$(ssh-agent -s)"

# add your private key
ssh-add ~/.ssh/id_rsa

# check access to the PIM enterprise repository
ssh git@distribution.akeneo.com -p 443
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
# show the mapping for a given index
curl -XGET 'http://localhost:9200/akeneo_pim_product/?pretty'

# check document for product with id X
curl -XGET 'http://localhost:9200/akeneo_pim_product/pim_catalog_product/X?pretty'
```

Use this [Postman collection](postman/pim-es-collection.json) and its [environment](postman/pim-es-environment.json) for other useful requests. Use them only for debugging purposes, never write in ES manually.

### Reset all indices and re-index the PIM

Download [scripts/elastic.sh](scripts/elastic.sh) and place it somewhere in a folder of your `$PATH` (`/usr/local/bin`).

Usage: `elastic.sh [use-docker]`
Note: `use-docker` will prefix all commands with `docker-compose exec fpm`.
