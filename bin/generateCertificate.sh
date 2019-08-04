#!/bin/bash
# Generate ssl certificates

# Echo functions
function e_header()  { echo -e "\n\033[1m$@\033[0m"; }
function e_success() { echo -e "\033[1;32m✔\033[0m $@"; }
function e_error()   { echo -e "\033[1;31m✖\033[0m $@"; }
function e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
function e_arrow_n() { echo -n -e "\033[1;34m➜\033[0m $@"; }

projectRoot=`dirname $0`
projectRoot=`readlink -f $projectRoot`
projectRoot=`dirname $projectRoot`
projectRoot=`dirname $projectRoot`

source "$projectRoot/.env"

certificateAuthorityPath="$projectRoot/.docker/web/ca"
certificatePath="$projectRoot/.docker/web/ssl"
certificateConfigPath="$projectRoot/.docker/web/sslConfig"
certificateTmpPath="$projectRoot/.docker/web/ca/tmp"

e_header Generating certificate

if [ -d $certificateTmpPath ]; then
  e_arrow Removing tmp dir
  rm -rf $certificateTmpPath
fi

e_arrow Creating tmp dir
mkdir $certificateTmpPath

cd $certificateTmpPath
e_arrow Creating signedcerts dir
mkdir signedcerts
e_arrow Creating private dir
mkdir private

e_arrow Creating certificate database
echo '01' > serial && touch index.txt

export OPENSSL_CONF=${certificateConfigPath}/caconfig.cnf

e_arrow Generating Certificate Authority
openssl req -x509 -newkey rsa:2048 -out cacert.pem -outform PEM -days 1825

export OPENSSL_CONF=${certificateConfigPath}/localhost.cnf

e_arrow Generating self signed certificate with Subject Alternative Name - SAN
openssl req -newkey rsa:2048 -keyout tempkey.pem -keyform PEM -out tempreq.pem -outform PEM

export OPENSSL_CONF=${certificateConfigPath}/caconfig.cnf

e_arrow Creating unencrypted certificate
openssl rsa -passin pass:supersecret < tempkey.pem > server_key.pem

e_arrow Signing the certificate
openssl ca -in tempreq.pem -out server_crt.pem -passin pass:supersecret

e_arrow Copying certificate authority
cp cacert.pem $certificateAuthorityPath/cacert.crt

e_arrow Copying private key
cp server_key.pem $certificatePath/private.rsa

e_arrow Copying signed certificate
cp server_crt.pem $certificatePath/public.crt