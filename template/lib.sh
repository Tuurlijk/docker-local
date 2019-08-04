#!/usr/bin/env bash
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

enable_install_tool() {
    e_arrow Enabling install tool
    touch /build/Web/typo3conf/ENABLE_INSTALL_TOOL
}

enable_first_install() {
    if [ ! -f /build/Web/typo3conf/AdditionalConfiguration.php ]; then
        e_arrow Creating FIRST_INSTALL file
        touch /build/Web/FIRST_INSTALL
    fi
}

copy_additional_configuration() {
    if [ ! -f /build/Web/typo3conf/AdditionalConfiguration.php ]; then
        e_arrow Copying additional configuration
        cp /configuration/template/${TEMPLATE}/typo3conf/AdditionalConfiguration.php /build/Web/typo3conf/
    fi
}

copy_composer_json() {
    if [ ! -f /build/composer.json ]; then
        e_arrow Setting up composer file
        cp --force /configuration/template/${TEMPLATE}/composer.json /build/
    fi
}

composer_install() {
    if [ ! -f composer.lock ]; then
        e_arrow Running composer install
        composer install
    fi
}

install_typo3() {
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
}

fix_permissions() {
    e_arrow Ensuring the webserver can read the files
    chmod -R ug+rwX,o+rX /build
}

show_entry_points() {
    e_header You can reach the your sites on the following urls:
    
    e_arrow "Default PHP https://${COMPOSE_PROJECT_NAME}.dev.local"
    e_arrow "Blackfire   https://${COMPOSE_PROJECT_NAME}.blackfire.local"
    e_arrow "Xdebug      https://${COMPOSE_PROJECT_NAME}.xdebug.local"
    e_arrow "Mailhog     https://${COMPOSE_PROJECT_NAME}.mail.local"

    echo
}

create_ramdisk_mountpoints