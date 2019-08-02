#!/bin/sh

# Initialization script with which you can set up your project

function e_header()  { echo -e "\n\033[1m$@\033[0m"; }
function e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
function e_success() { echo -e "\033[1;32m✔\033[0m $@"; }

e_header Setting up default

e_arrow Creating index.php
cp --force /configuration/template/default/index.php /build/Web/

e_arrow Fixing permissions
chmod -R ug+rwX,o+rX /build
chown -R 1000:1000 /build
e_success All done
