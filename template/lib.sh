#!/usr/bin/env bash
#
# Library

e_header()  { echo -e "\n\033[1m$@\033[0m"; }
e_arrow()   { echo -e "\033[1;34m➜\033[0m $@"; }
e_success() { echo -e "\033[1;32m✔\033[0m $@"; }

wait_for_database() {
    e_header Waiting for database in container ${COMPOSE_PROJECT_NAME}_db to come up
    while ! mysql -h ${COMPOSE_PROJECT_NAME}_db -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e status &> /dev/null ; do
        sleep 1
    done

    e_success Database is up
}

ensure_read_access_to_db_folder() {
  if [ -d "/var/lib/mysql" ]; then
    e_arrow Giving host user access to database folder
    chown -R :${GID:-1000} /var/lib/mysql
  fi
}

enable_install_tool() {
    e_arrow Enabling install tool
    mkdir -p /build/public/typo3conf
    touch /build/public/typo3conf/ENABLE_INSTALL_TOOL
}

enable_first_install() {
    if [ ! -f /build/public/typo3conf/AdditionalConfiguration.php ]; then
        e_arrow Creating FIRST_INSTALL file
        touch /build/public/FIRST_INSTALL
    fi
}

copy_additional_configuration() {
    if [ ! -f /build/public/typo3conf/AdditionalConfiguration.php ]; then
        e_arrow Copying additional configuration
        cp /configuration/template/${TEMPLATE}/typo3conf/AdditionalConfiguration.php /build/public/typo3conf/
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

show_entry_points() {
    e_header You can reach your sites on the following urls:

    e_arrow "Web + PHP            https://${COMPOSE_PROJECT_NAME}.dev.local        https://${COMPOSE_PROJECT_NAME}.dev.local/typo3"
    e_arrow "Web + PHP-Blackfire  https://${COMPOSE_PROJECT_NAME}.blackfire.local  https://${COMPOSE_PROJECT_NAME}.blackfire.local/typo3"
    e_arrow "Web + PHP-Xdebug     https://${COMPOSE_PROJECT_NAME}.xdebug.local     https://${COMPOSE_PROJECT_NAME}.xdebug.local/typo3"
    e_arrow "Mail                 https://${COMPOSE_PROJECT_NAME}.mail.local"
    e_arrow "Docker Logs          https://${COMPOSE_PROJECT_NAME}.logs.local"

    echo
}
