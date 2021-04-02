#!/bin/bash
# Dump the database and place it in .docker/db so it can be imported on the next run

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

dumpPath="$projectRoot/.docker/db/dump"
dumpFile=${dumpPath}/dump.sql
db=${MYSQL_DATABASE}

e_header Dumping database ${db}
e_arrow Creating backup file from current dump
if [[ -e ${dumpFile}.gz ]]; then
    mv ${dumpFile}.gz ${dumpFile}.gz.bak
fi
e_arrow Creating backup of database ${MYSQL_DATABASE}
docker-compose -f .docker/docker-compose.yml exec -T db mysqldump -p${MYSQL_ROOT_PASSWORD} ${db} > ${dumpFile}
if [[ $? -gt 0 ]]; then
    e_error Failed to create backup
    e_arrow Restoring backup file to dump
    mv ${dumpFile}.gz.bak ${dumpFile}.gz
    e_arrow Removing failed dump file
    rm ${dumpFile}
else
#    e_arrow Removing first line from dump
#    sed -i '1d' ${dumpFile}
    e_arrow Gzipping dump
    gzip ${dumpFile}
    e_arrow Fixing permissions
    chmod o+r ${dumpFile}.gz
fi
