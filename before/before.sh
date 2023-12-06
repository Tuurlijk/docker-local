#!/usr/bin/env bash

e_header()  { echo -e "\n\033[1m$@\033[0m"; }
e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
e_success() { echo -e "\033[1;32m✔\033[0m $@"; }

e_header Ensuring Mysql can read and write to the import / export folders

chmod -R go+rX /configuration/db/import /configuration/db/dump

e_success All done
