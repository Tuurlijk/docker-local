#!/bin/bash

# Initialization script with which you can set up your project

function e_header()  { echo -e "\n\033[1m$@\033[0m"; }
function e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
function e_success() { echo -e "\033[1;32m✔\033[0m $@"; }


e_header Waiting for db to come up
while ! mysql -h db -u root -p${MYSQL_ROOT_PASSWORD} -e status &> /dev/null ; do
#  echo -n '.'
  sleep 1
done

e_success OK database is up

e_header Setting up TYPO3

cd /var/www/html

if [ ! -f composer.lock ]; then
  e_arrow Running composer install
  composer install
fi

if [ ! -f typo3conf/LocalConfiguration.php ]; then
  e_arrow Installing TYPO3
  ./bin/typo3cms install:setup --non-interactive \
    --database-user-name="root" \
    --database-user-password="${MYSQL_ROOT_PASSWORD}" \
    --database-host-name="db" \
    --database-port="3306" \
    --database-name="${MYSQL_DATABASE}" \
    --admin-user-name="admin" \
    --admin-password="${MYSQL_PASSWORD}" \
    --site-name="TYPO3 v9" \
    --site-setup-type="site" \
    --use-existing-database
fi

e_arrow Updating database
./bin/typo3cms database:updateschema table.add,table.change,field.add,field.change

#e_arrow Setting up autologin
#./bin/typo3cms extension:setupactive autologin

e_arrow Fixing permissions
chmod -R ug+rwX,o+rX /var/www/html

e_success All done
