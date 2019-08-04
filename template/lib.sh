#!/bin/bash
#
# Library

e_header()  { echo -e "\n\033[1m$@\033[0m"; }
e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
e_success() { echo -e "\033[1;32m✔\033[0m $@"; }

# This is needed to ensure that the mountpoints are owned by the user and not by root
create_ramdisk_mountpoints() {
  e_arrow Creating ramdisk mountpoints
  mkdir -p /build/Web/typo3temp/ /build/var
}

wait_for_database() {
  e_header Waiting for db to come up
  while ! mysql -h db -u root -p${MYSQL_ROOT_PASSWORD} -e status &> /dev/null ; do
    sleep 1
  done

  e_success Database is up
}