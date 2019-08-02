#!/bin/sh

# Initialization script with which you can set up your project

function e_header()  { echo -e "\n\033[1m$@\033[0m"; }
function e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
function e_success() { echo -e "\033[1;32m✔\033[0m $@"; }

e_header Setting up TYPO3 9

e_arrow Ensuring typo3conf exists
mkdir -p /build/Web/typo3conf/

e_arrow Ensuring var exists
mkdir -p /build/var

e_arrow Enabling install tool
touch /build/Web/typo3conf/ENABLE_INSTALL_TOOL

if [ ! -f /build/Web/typo3conf/AdditionalConfiguration.php ]; then
  e_arrow Creating FIRST_INSTALL file
  touch /build/Web/FIRST_INSTALL
fi

e_arrow Populating additional typo3conf files
cp --recursive --force /configuration/template/TYPO3-v9/typo3conf/* /build/Web/typo3conf/

e_arrow Setting up composer file
cp --force /configuration/template/TYPO3-v9/composer.json /build/

e_arrow Fixing permissions
chmod -R ug+rwX,o+rX /build
chown -R 1000:1000 /build
e_success All done
