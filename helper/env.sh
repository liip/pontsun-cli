#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PONTSUN_CLI_DIR_REL=${PONTSUN_CLI_DIR:-$DIR/../}
PONTSUN_CLI_DIR="$( cd ${PONTSUN_CLI_DIR_REL} && pwd )"

set +e
# try to find the toplevel directory
GIT_TOPLEVEL=$(git rev-parse --show-superproject-working-tree 2> /dev/null)

if [ -z $GIT_TOPLEVEL ]; then
 GIT_TOPLEVEL=$(git rev-parse --show-toplevel 2> /dev/null)
  if [ -z $GIT_TOPLEVEL ]; then
    GIT_TOPLEVEL=$PONTSUN_CLI_DIR
  fi
fi
set -e
PONTSUN_DIR_REL=${PONTSUN_DIR:-$GIT_TOPLEVEL/../pontsun}
PONTSUN_DIR="$( cd ${PONTSUN_DIR_REL} && pwd )"

# Load env file
set -a
# load env variables but only if not set already

if [[ ! -f ${PONTSUN_CLI_DIR}/.env ]]; then
  RED='\033[0;31m'
  NC='\033[0m' # No Color

  printf "${RED}${PONTSUN_CLI_DIR}/.env does not exist!${NC}\nPlease copy it with:\n"
  printf "cp ${PONTSUN_CLI_DIR}/.env.example ${PONTSUN_CLI_DIR}/.env\n"
  printf  "and adjust it.\n"
  exit 1
fi
test -f ${PONTSUN_CLI_DIR}/.env && source <(grep -v '^\s*#' ${PONTSUN_CLI_DIR}/.env | sed -E 's|^ *([^=]+)=(.*)$|: ${\1=\2}; export \1|g')

PONTSUN_CLI_SERVICES="traefik"
PONTSUN_CLI_COMPOSE_FILES="-f docker-compose.yml"

# start ssh agent on OS X
if [[ "$OSTYPE" == "darwin"* ]]; then
  PONTSUN_CLI_COMPOSE_FILES="${PONTSUN_CLI_COMPOSE_FILES} -f docker-compose.ssh-agent.yml"
  PONTSUN_CLI_SERVICES="$PONTSUN_CLI_SERVICES sshagent"
fi

if [[ "$PONTSUN_CLI_PORTAINER" != "no" ]]; then
  PONTSUN_CLI_SERVICES="$PONTSUN_CLI_SERVICES portainer"
fi
