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
