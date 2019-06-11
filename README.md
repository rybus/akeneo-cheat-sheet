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

## Symfony

```bash
# list available commands, also recreates the cache
bin/console

# list existing services, append with '| grep service_name' to narrow your request
bin/console debug:container

# list existing parameters, append with '| grep parameter_name' to narrow your request
bin/console debug:container --parameters

# synchronize MySQL schema with your .orm.yml files
bin/console doctrine:schema:update --dump-sql         # diff only
bin/console doctrine:schema:update --dump-sql --force # diff + perform changes

# execute MySQL migrations
bin/console doctrine:migrateion:migrate --env=prod # append with '--dry-run' for a no-risk experience
```

## Akeneo

### Installation

```bash
# Installation of dependencies
composer update
yarn install

# Installation of the PIM
rm -rf var/cache/*
bin/console --env=prod pim:install --force --clean
yarn run webpack

# (Re)deploy assets
rm -rf var/cache/*
bin/console --env=prod pim:installer:assets --symlink --clean
yarn run webpack
# + clear your browser cache manually
```

### Work with Akeneo

```bash
# List filters and operators usable for rules and product query builders
bin/console pim:product:query-help

# Launches the job consumer daemon, append with '--run-once' to execute one job only and terminate
bin/console akeneo:batch:job-queue-consumer-daemon

# Execute one job, bypassing the job consumer, append with '-vvv' for explicit output
bin/console akeneo:batch:job job_code
```

## Akeneo Cloud (PaaS)

```bash
# SSH connection
ssh akeneo@server.cloud.akeneo.com

# Clear properly PIM’s cache (doctrine).
# Stop php-fpm and supervisor
# Delete PIM cache folder+warmup
# Start php-fpm and supervisor
partners_clear_cache


# Show status or start/restart php-fpm daemon.
# PHP version number may vary depending on installation
partners_php7.2-fpm [start|status|restart]
```
