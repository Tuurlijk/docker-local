#!/bin/bash
# Import a database

# Echo functions
function e_header()  { echo -e "\n\033[1m$@\033[0m"; }
function e_success() { echo -e "\033[1;32m✔\033[0m $@"; }
function e_error()   { echo -e "\033[1;31m✖\033[0m $@"; }
function e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
function e_arrow_n() { echo -n -e "\033[1;34m➜\033[0m $@"; }

projectRoot=`dirname $0`
projectRoot=`readlink -f $projectRoot`
projectRoot=`dirname $projectRoot`
projectRoot=`dirname $projectRoot`

source "$projectRoot/.env"

if [[ $# -eq 0 ]] || [[ ! -f $1 ]]; then
    e_header Usage:
    echo $0 dump.sql.gz
    exit
fi

e_arrow Importing data from $1

case "$1" in
*.gz)
        zcat $1 | docker-compose -f .docker/docker-compose.yml exec -T db mysql -u root ${MYSQL_DATABASE} -p${MYSQL_ROOT_PASSWORD}
        ;;
*.tgz)
        e_error Can\'t handle tgz files . . .
        ;;
*)
        docker-compose -f .docker/docker-compose.yml exec -T db mysql -u root ${MYSQL_DATABASE} -p${MYSQL_ROOT_PASSWORD} < ${1}
        ;;
esac