#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/helper/env.sh

# down project docker, if it exists
$PONTSUN_CLI_DIR/down-project.sh

cd $PONTSUN_DIR/containers/

docker-compose $PONTSUN_CLI_COMPOSE_FILES down
