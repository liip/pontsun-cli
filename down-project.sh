#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/helper/env.sh

# down project docker, if it exists
if [[ -f $GIT_TOPLEVEL/docker-compose.yml ]]; then
  echo "***"
  echo "Stop project docker compose"
  echo "***"
  cd $GIT_TOPLEVEL
  docker-compose down
fi
