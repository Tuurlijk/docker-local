#!/usr/bin/env bash

source /configuration/template/lib.sh

e_header Setting up ${TEMPLATE}

enable_install_tool
enable_first_install
copy_additional_configuration
copy_composer_json

e_success All done
