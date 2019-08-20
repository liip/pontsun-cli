#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/helper/env.sh


cd $PONTSUN_DIR/containers/


CMD="docker-compose ${PONTSUN_CLI_COMPOSE_FILES} up -d ${PONTSUN_CLI_SERVICES}"
echo "***"
echo "Starting pontsun with:"
echo "cd $PONTSUN_DIR/containers && $CMD"
echo "***"

$CMD

# start project docker, if it exists
if [[ -f $GIT_TOPLEVEL/docker-compose.yml ]]; then
  echo "***"
  echo "Start project docker compose"
  echo "***"
  cd $GIT_TOPLEVEL
  docker-compose up -d
fi


