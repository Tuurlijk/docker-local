#!/usr/bin/env bash
#
# Initialization script with which you can set up your project

source /configuration/template/lib.sh

wait_for_database

e_header Setting up ${TEMPLATE}

fix_permissions

e_success All done

show_entry_points