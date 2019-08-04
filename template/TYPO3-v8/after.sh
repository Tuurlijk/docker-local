#!/usr/bin/env bash

source /configuration/template/lib.sh

wait_for_database

e_header Setting up TYPO3

cd /var/www/html || exit

composer_install

install_typo3

e_arrow Setting up autologin
./bin/typo3cms extension:setupactive autologin

fix_permissions

e_success All done

show_entry_points