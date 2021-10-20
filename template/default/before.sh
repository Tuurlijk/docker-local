#!/usr/bin/env bash
#
# Initialize project

source /configuration/template/lib.sh

e_header Setting up ${TEMPLATE}

e_arrow Copying phpinfo file
cp /configuration/template/${TEMPLATE}/index.php /build/public

e_success All done
