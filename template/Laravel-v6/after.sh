#!/usr/bin/env bash
#
# Initialization script with which you can set up your project

source /configuration/template/lib.sh

wait_for_database

e_header Setting up ${TEMPLATE}

cd /var/www/html || exit

composer_install

e_success All done

show_entry_points
