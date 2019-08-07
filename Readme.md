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
cp .docker/.env .
docker-compose -f .docker/docker-compose.yml up
```

Fo extra ease of use you can create an alias:
```bash
alias dc="docker-compose -f .docker/docker-compose.yml"
```

## Ephemeral

The containers are ephemeral as suggested in [Best practices for writing Docker files](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

*The image defined by your Dockerfile should generate containers that are as ephemeral as possible. By “ephemeral”, we mean that the container can be stopped and destroyed, then rebuilt and replaced with an absolute minimum set up and configuration.*

Of course all the files in your project directory remain in place, but temporary stuff like `Web/typo3temp` and `var` run in ramdisk (tmpfs) volumes that will be removed when the machines stop.

The database also runs in a tmpfs volume. If you want to save it, please use `./.docker/bin/dump.sh`. This will create a gzipped dump in `.docker/db/` that will be automatically re-imported into the db instance when it starts again.

If your database is so big that it takes too much time to import it often, consider using a regular docker volume for the database:

```yaml
  db:
    image: mariadb:latest
    env_file:
      - ../.env
    volumes:
      - ./db:/docker-entrypoint-initdb.d/:ro
      - ./db/mysql.cnf:/etc/mysql/mariadb.conf.d/zzz-custom.cnf:ro
      - ./db/lib/mysql:/var/lib/mysql
``` 

This will store the database in `.docker/db/lib/mysql`. Make sure you create `.docker/db/lib/mysql` or the machine will not start ;-)

## Configuration
Each container may use configuration files from the `.docker` folder.

The environment file `/.env` defines some important variables:

### COMPOSE_PROJECT_NAME
The project name is used in the domain names of the http containers:
* [prefix.dev.local](https://prefix.dev.local) - default PHP
* [prefix.xdebug.local](https://prefix.xdebug.local) / [prefix.debug.local](https://prefix.debug.local) / [prefix.xdbg.local](https://prefix.xdbg.local) - Xdebug enabled PHP
* [prefix.blackfire.local](https://prefix.blackfire.local) / [prefix.bf.local](https://prefix.bf.local) / [prefix.fire.local](https://prefix.fire.local) / [prefix.black.local](https://prefix.black.local) - Blackfire enabled PHP
* [prefix.mail.local](https://prefix.mail.local) - Mailhog
* [prefix.logs.local](https://prefix.logs.local) - Dozzle

### TEMPLATE ###
Use a template to get an installation up quickly. Each template has a `before.sh` file to set up the environment before any machine starts and an `after.sh` file to set up the environment after the machines have started. This may fix permissions and copy over files like composer.json and AdditionalConfiguration.php.

Please keep in mind that you may need to tweak the MariaDb and PHP versions for the older TYPO3 versions.

Choose from: 
* TYPO3-v7
* TYPO3-v8
* TYPO3-v9
* TYPO3-v10
* Neos-4

Add your own templates in .docker/template/

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

## Fixing permissions
The most important thing here is to set up the proper permissions inside the containers so that nginx can read and php-fpm can read and write files.

You can see your uid and gid by doing `id -u` and `id -g`.

On many systems these values will be `1000`. Now we need to make sure that the PHP process runs as that user and group so it can read and write files in your web directory.

If your uid and gid differ from 1000, set the `UID` and `GID` env vars in the `.env` file.

## Importing a database
Any files in `.docker/db/` ending in `tar.gz` or `gz` will be imported.

## Dumping a database
There is a script in `.docker/bin/` called `dump.sh`. It uses the database credentials defined in the `.env` file to dump the database from the database host. You can execute it by doing:
```bash
composer dd
# Or
composer dump-database
# Or
./.docker/bin/dump.sh
```

## Host naming inside the containers

All containers are started within their own subnet. They can reach each other by the *service names* specified in `.docker/docker-compose.yml`. So the `php` machine can reference the `redis` machine by using hostname **redis**.

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

You can regenerate your own custom authority and certificates using `.docker/bin/generateCertificate.sh`. The configuration files are in `.docker/web/sslConfig`. If you want to add a wildcard domain to the SAN list, run `.docker/bin/reGenerateCertificate.sh`.

## Known Issues
* Sometimes the var and Web directories get created with owner and group root. This breaks the installation.
* Mariadb fails to set the configured charset on first image start. This may be a problem of the stock [MariaDb docker image](https://hub.docker.com/_/mariadb).