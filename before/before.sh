#!/usr/bin/env bash

e_header()  { echo -e "\n\033[1m$@\033[0m"; }
e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
e_success() { echo -e "\033[1;32m✔\033[0m $@"; }

e_header Ensuring Mysql can read and write to the import / export folders

chmod -R go+rX /configuration/db/import /configuration/db/dump

e_header Setting user id to ${UID:-1000} and group id to ${GID:-1000}

export USER_ID=${UID:-1000}
export GROUP_ID=${GID:-1000}

awk -F: -v OFS=: '$1 ~ "^dev:" { $3=ENVIRON["USER_ID"] } $1 ~ "^dev:" { $4=ENVIRON["GROUP_ID"] }1' /etc/passwd > /tmp/passwd
cat /tmp/passwd > /etc/passwd
awk -F: -v OFS=: '$1 ~ "^dev:" { $3=ENVIRON["USER_ID"] } $1 ~ "^dev:" { $4=ENVIRON["GROUP_ID"] }1' /etc/passwd- > /tmp/passwd-
cat /tmp/passwd- > /etc/passwd-

awk -F: -v OFS=: '$1 ~ "^dev:" { $3=ENVIRON["GROUP_ID"] }1' /etc/group > /tmp/group
cat /tmp/group > /etc/group
awk -F: -v OFS=: '$1 ~ "^dev:" { $3=ENVIRON["GROUP_ID"] }1' /etc/group- > /tmp/group-
cat /tmp/group- > /etc/group-

e_success All done
