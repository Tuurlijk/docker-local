# docker compose setup for local development
This development environment uses as much default docker containers as possible.

* Default [nginx](https://hub.docker.com/r/fholzer/nginx-brotli) container - Nginx container with brotli support
* Default [mariadb](https://hub.docker.com/_/mariadb) container - serves the database
* Default [mailhog](https://hub.docker.com/r/mailhog/mailhog) container - catches all outgoing mail and displays it
* Default [docker-hoster](https://hub.docker.com/r/dvdarias/docker-hoster) container - makes the containers accessible by name
* Default [busybox](https://hub.docker.com/_/busybox) container - used for initialization
* Default [blackfire](https://hub.docker.com/r/blackfire/blackfire) container - used for profiling your site
* Default [ngrok](https://hub.docker.com/r/wernight/ngrok) container - used to share your local site with the world
* Default [dozzle](https://hub.docker.com/r/amir20/dozzle) container - used to inspect the logs in browser
* Slightly changed php container (added graphicsmagick, rsync and some php modules) - serves up php

Disclaimer: This was developed and tested on Linux. OSX has some limitations when it comes to easy access to docker hosts by hostname: [Docker Known limitations, use cases, and workarounds](https://docs.docker.com/docker-for-mac/networking/#known-limitations-use-cases-and-workarounds)

Pull requests are welcome ;-)

## Installation

```bash
mkdir project && cd project
git clone https://github.com/Tuurlijk/docker-local.git .docker
ln -s .docker/.env .env
```

### Make sure the containers can read and write your files
The different container processes run under different user ids. The containers must be able to read, and some must be able to write host files mounted as volumes inside the container. The default user and group id's the processes are set to run as are 1000 and 1000. If your uid and gid are not `1000`, set the `UID` and `GID` env vars in the `.env` file.

You can see your uid and gid by doing `id -u` and `id -g`.

### Set the project name in .env

Set up a project name in the `.env` file.
```bash
# Project name
COMPOSE_PROJECT_NAME=my_great_project
```

### Start the environment

Adjust other env vars if needed. When you are done, you can start the environment with:
```bash
docker-compose -f .docker/docker-compose.yml up
```

For ease of use you can create an alias:
```bash
alias dc="docker-compose -f .docker/docker-compose.yml"
```

### The service user

The services in the `web` and `php*` containers run under user **dev**. If you want to login to the php container as that user you can do:

```bash
dev exec -u dev php /bin/bash
```

You can create an alias so you don't have to type the user out all the time.
```bash
alias de="dev exec -u dev"
```

### Aliases

Bonus aliases:
```bash
# Colorful messages
e_header()  { echo -e "\n\033[1m$@\033[0m"; }
e_success() { echo -e " \033[1;32m✔\033[0m  $@"; }
e_error()   { echo -e " \033[1;31m✖\033[0m  $@"; }

# Docker
alias d=docker
alias dp="docker ps"
alias dc="docker-compose -f .docker/docker-compose.yml"
alias dev="docker-compose -f .docker/docker-compose.yml"
alias down='f(){ dev rm -fsv $@; unset -f f; }; f'
alias up='f(){ dev up -d $@ && dev logs -f before_script after_script; unset -f f; }; f'
alias on=up
alias off=down
alias re='f(){ dev rm -fsv $@ && dev build $@ && dev up -d $@ && dev logs -f before_script after_script; unset -f f; }; f'
alias offon=re
alias ds="dev exec -u dev php bash -l"
alias de="dev exec -u dev"
alias cf='e_header "Running typo3cms cache:flush"; ds -c "./public/bin/typo3cms cache:flush"; e_success Done'
alias ct='e_header "Clearing ./public/typo3temp/*"; ds -c "echo removing \`find ./public/typo3temp/ -type f | wc -l\` files; rm -rf ./public/typo3temp/*"; e_success Done'
```

## SSL support
Import `.docker/web/ca/cacert.crt` into your browser. Allow it authenticate websites.
This was generated using: https://gist.github.com/jchandra74/36d5f8d0e11960dd8f80260801109ab0

The provided certificates have wildcards for:
* *.dev.local
* *.blackfire.local
* *.black.local
* *.fire.local
* *.bf.local
* *.xdebug.local
* *.debug.local
* *.xdbg.local
* *.mail.local
* *.logs.local

This makes is possible to visit `prefix.dev.local` securely. If you want to use the blackfire php backend, you can visit `prefix.blackfire.local` or `prefix.bf.local`.

To make the certificates available for the whole OS, do something along the lines of:
```bash
sudo cp .docker/web/ca/cacert.crt /usr/local/share/ca-certificates/docker-local.crt
sudo update-ca-certificates
```
Or, if you are on Arch:
```bash
sudo cp .docker/web/ca/cacert.crt etc/ca-certificates/trust-source/anchors/docker-local.crt
sudo trust extract-compat
```

You can regenerate your own custom authority and certificates using `.docker/bin/generateCertificate.sh`. The configuration files are in `.docker/web/sslConfig`. If you want to add a wildcard domain to the SAN list, run `.docker/bin/reGenerateCertificate.sh`.

## Configuration
Each container may use configuration files from the `.docker` folder.

The environment file `/.env` defines some important variables. Check yout platform documentation so you know what version of PHP and Mariadb you need. For TYPO3 you can find the requirements here: https://get.typo3.org/version

### COMPOSE_PROJECT_NAME
The project name is used in the domain names of the http containers:
* [prefix.dev.local](https://prefix.dev.local) - default PHP
* [prefix.xdebug.local](https://prefix.xdebug.local) / [prefix.debug.local](https://prefix.debug.local) / [prefix.xdbg.local](https://prefix.xdbg.local) - Xdebug enabled PHP
* [prefix.blackfire.local](https://prefix.blackfire.local) / [prefix.bf.local](https://prefix.bf.local) / [prefix.fire.local](https://prefix.fire.local) / [prefix.black.local](https://prefix.black.local) - Blackfire enabled PHP
* [prefix.mail.local](https://prefix.mail.local) - Mailhog
* [prefix.logs.local](https://prefix.logs.local) - Dozzle

All environments are started within their own subnet. They can reach each other by the *service name* or *container_name* specified in `.docker/docker-compose.yml`. So the `php` machine can reference the `redis` machine by using hostname **redis** or **container_name: ${COMPOSE_PROJECT_NAME}_web**. So if your project name is **babel** the `php` machine can reach the `redis` machine by using **babel_redis** as hostname.

### PHP versions
There are different PHP versions available. The default is PHP 7.4

#### PHP_VERSION
One of: `5.6`, `7.1`, `7.2`, `7.3`, `7.4`, `8.0`, `8.1`

### Database version
[One of the mariadb versions](https://hub.docker.com/_/mariadb). The default is 10.2

#### DATABASE_VERSION
One of teh tags on https://hub.docker.com/_/mariadb

### mysql database credentials

#### MYSQL_DATABASE
The name of the database that mysql will import the dump into

#### MYSQL_USER
The name of the mysql user

#### MYSQL_PASSWORD
The password of the mysql user

#### MYSQL_ROOT_PASSWORD
The password of the mysql root user

### Ngrok
Expose a local web server to the internet. Share your local development environment with others

#### NGROK_AUTH
Your token from https://dashboard.ngrok.com/auth

*This option is commented out by default because you are better of setting it globally in your shell environment.*

#### NGROK_PORT=prefix.dev.local:443
Hostname and port of the exposed website

#### NGROK_USERNAME
Username for htaccess based authentication of the exposed website

#### NGROK_PASSWORD
Password for htaccess based authentication of the exposed website

### Blackfire credentials
Use blackfire to profile your PHP code. Get the credentials from https://blackfire.io/my/settings/credentials

#### BLACKFIRE_CLIENT_ID
Client id

*This option is commented out by default because you are better of setting it globally in your shell environment.*

#### BLACKFIRE_CLIENT_TOKEN
Client token

*This option is commented out by default because you are better of setting it globally in your shell environment.*

#### BLACKFIRE_SERVER_ID
Server id

*This option is commented out by default because you are better of setting it globally in your shell environment.*

#### BLACKFIRE_SERVER_TOKEN
Server token

*This option is commented out by default because you are better of setting it globally in your shell environment.*

#### HOSTMAP_IMAGE
By default the **[dvdarias/docker-hoster](https://hub.docker.com/r/dvdarias/docker-hoster)** image is started. This may give trouble if you start multiple environments. Docker-hoster does not seem to cope too well. An alternative is to start a standalone image that does docker dns like [kevinjqiu/resolvable](https://hub.docker.com/r/kevinjqiu/resolvable).

If you opt for that, you can set **HOSTMAP_IMAGE** to **bash**.

Example resolvable config:
```yaml
version: "3"
services:
  resolvable:
    image: kevinjqiu/resolvable
    restart: always
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - /etc/resolv.conf:/tmp/resolv.conf
```

### TEMPLATE ###
Use a template to get an installation up quickly. Each template has a `before.sh` file to set up the environment before any machine starts and an `after.sh` file to set up the environment after the machines have started. This may fix permissions and copy over files like composer.json and AdditionalConfiguration.php.

Please keep in mind that you may need to tweak the MariaDb and PHP versions for the older TYPO3 versions.

Choose from:
* empty
* default
* TYPO3-v7
* TYPO3-v8
* TYPO3-v9
* TYPO3-v10
* TYPO3-v11
* Neos-v4

Add your own templates in .docker/template/

## Scripts
There are a few helper scripts in `.docker/bin`. Most of these are meant to be executed from the project root (where the .env file is stored).

### Dumping a database
There is a script in `.docker/bin/` called `dump.sh`. It uses the database credentials defined in the `.env` file to dump the database from the database host. You can execute it by doing:
```bash
./.docker/bin/dump.sh
```
The database dump will be stored in `.docker/db/dump`.

### Importing a database
There is a script in `.docker/bin/` called `import.sh`. It uses the database credentials defined in the `.env` file to import a database to the database host. You can execute it by doing:
```bash
./.docker/bin/import.sh dumpfile.sql.gz
```

### Automatically importing a database
Any files in `.docker/db/import` ending in `tar.gz`, `sql` or `gz` will be imported. This can be of use to you if you wish to execute SQL on each run of the db container. Also nice if you want to run a databbase in ram, because then you will need to re-import the data on each run of the container.

## Run database in ram
The database in the container is already pretty fast if you have a ssd, But if you want more speed, you can run it in ram.

The database can run in a tmpfs volume. If you want to save it, please use `./.docker/bin/dump.sh`. This will create a gzipped dump in `.docker/db/dump`.

If you want to run the db in ram uncomment the **dbRamdisk** line:

```yaml
  db:
    image: mariadb
    container_name: ${COMPOSE_PROJECT_NAME}_db
    env_file:
      - $PWD/.env
    volumes:
      #- dbRamdisk:/var/lib/mysql
      - ./db/mariadb.cnf:/etc/mysql/mariadb.cnf:ro
      - ./db/mariadb.cnf:/etc/mysql/conf.d/mariadb.cnf:ro
      - ./db:/docker-entrypoint-initdb.d/:ro
    depends_on:
      - before_script
```

And also uncomment the dbRamdisk volume lines at the end:

```yaml
#volumes:
#  dbRamdisk:
#    driver_opts:
#      type: tmpfs
#      device: tmpfs
#      o: "noatime,noexec,nodiratime,nodev,nosuid,async,mode=0770,uid=${UID:-1000},gid=${GID:-1000}"
```

## Ephemeral

The containers are ephemeral as suggested in [Best practices for writing Docker files](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

*The image defined by your Dockerfile should generate containers that are as ephemeral as possible. By “ephemeral”, we mean that the container can be stopped and destroyed, then rebuilt and replaced with an absolute minimum set up and configuration.*

Of course all the files in your project directory remain in place, but temporary stuff like `public/typo3temp` and `var` run in ramdisk (tmpfs) volumes that will be removed when the machines stop.

## PHPStorm Xdebug
In `docker-compose.yml` an environment variable is set: `PHP_IDE_CONFIG=serverName=${COMPOSE_PROJECT_NAME}`. Make sure that you have this [server configured in PHPStorm](https://www.jetbrains.com/help/phpstorm/servers.html). The **name** of the server must be the value of your `COMPOSE_PROJECT_NAME`.

## Cool stuff

[lazydocker](https://github.com/jesseduffield/lazydocker) cli tool for inspecting your docker environment

## Known Issues
* Sometimes the var and Web directories get created with owner and group root. This breaks the installation.
* Mariadb fails to set the configured charset on first image start. This may be a problem of the stock [MariaDb docker image](https://hub.docker.com/_/mariadb).
