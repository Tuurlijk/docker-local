#!/bin/bash

source ../lib.sh

e_header Setting up TYPO3

e_arrow Ensuring typo3conf exists
mkdir -p /build/Web/typo3conf/

e_arrow Enabling install tool
touch /build/Web/typo3conf/ENABLE_INSTALL_TOOL

if [ ! -f /build/Web/typo3conf/AdditionalConfiguration.php ]; then
  e_arrow Creating FIRST_INSTALL file
  touch /build/Web/FIRST_INSTALL
fi

if [ ! -f /build/Web/typo3conf/AdditionalConfiguration.php ]; then
  e_arrow Populating additional typo3conf files
  cp --recursive --force /configuration/template/${TEMPLATE}/typo3conf/* /build/Web/typo3conf/
fi

if [ ! -f /build/composer.json ]; then
  e_arrow Setting up composer file
  cp --force /configuration/template/${TEMPLATE}/composer.json /build/
fi

e_arrow Fixing permissions
chmod -R ug+rwX,o+rX /build

e_success All done
