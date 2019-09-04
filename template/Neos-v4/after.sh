#!/usr/bin/env bash

source /configuration/template/lib.sh

e_header Setting up ${TEMPLATE}

cd /var/www/html || exit

composer_install

fix_permissions

show_entry_points