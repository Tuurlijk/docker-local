#!/usr/bin/env bash

source /configuration/template/lib.sh

wait_for_database

e_header Setting up TYPO3

cd /var/www/html || exit

composer_install

e_success All done

show_entry_points