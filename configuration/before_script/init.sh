#!/bin/sh

# Initialization script with which you can set up your project

function e_header()  { echo -e "\n\033[1m$@\033[0m"; }
function e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
function e_success() { echo -e "\033[1;32m✔\033[0m $@"; }

e_header Setting up TYPO3

e_arrow Populating additional typo3conf files
cp --recursive --force /configuration/before_script/typo3conf/* /build/Web/typo3conf/

e_arrow Enabling install tool
touch /build/Web/typo3conf/ENABLE_INSTALL_TOOL

e_arrow Fixing permissions
chmod -R ug+rwX,o+rX /build/vendor /build/Web

e_success All done
