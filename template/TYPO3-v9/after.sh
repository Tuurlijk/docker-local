#!/usr/bin/env bash

source /configuration/template/lib.sh

wait_for_database

e_header Setting up ${TEMPLATE}

cd /var/www/html || exit

composer_install

install_typo3

e_arrow Updating database
./bin/typo3cms database:updateschema table.add,table.change,field.add,field.change

#e_arrow Setting up autologin
#./bin/typo3cms extension:setupactive autologin

e_success All done

show_entry_points
