#!/bin/bash

# Initialization script with which you can set up your project

function e_header()  { echo -e "\n\033[1m$@\033[0m"; }
function e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
function e_success() { echo -e "\033[1;32m✔\033[0m $@"; }


e_header Waiting for db to come up
while ! mysql -h db -u root -p${MYSQL_ROOT_PASSWORD} -e status &> /dev/null ; do
#  echo -n '.'
  sleep 1
done

e_success OK database is up

e_success All done
