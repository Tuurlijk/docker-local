#!/usr/bin/env bash
#
# Initialize project

source /configuration/template/lib.sh

e_header Setting up ${TEMPLATE}

copy_composer_json

e_success All done
