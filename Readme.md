# docker compose setup for local development
This development environment uses as much default docker containers as possible.

* Default [nginx](https://hub.docker.com/_/nginx) container - serves web pages
* Default [mariadb](https://hub.docker.com/_/mariadb) container - serves the database
* Default [mailhog](https://hub.docker.com/r/mailhog/mailhog) container - catches all outgoing mail and displays it
* Default [docker-hoster](https://hub.docker.com/r/dvdarias/docker-hoster) container - makes the containers accessible by name
* Default [busybox](https://hub.docker.com/_/busybox) container - used for initialization
* Slightly changed php container (added graphicsmagick, rsync and some php modules) - serves up php

## Installation

```bash
git clone https://github.com/Tuurlijk/docker-local.git
cd docker-local
cp .env.example .env
docker-compose up
```

## Configuration
Each container may use configuration files from the `.docker` folder.

The environment file `/.env` defines some important variables:

### COMPOSE_PROJECT_NAME
The prefix of the containers. Your containers will come up as: `prefix_db_1`. The http container will be accessible on:
* prefix.dev.local
* prefix.xdebug.local
* prefix.xdbg.local
* prefix.blackfire.local
* prefix.bf.local

### WEB_HOSTNAME
The hostname where you can reach the website.

### CONFIGURATION_ROOT
The relative path to the configuration folder. If you copy the .env and docker-compose.yml file to your project root, you can point to this configuration folder. This way you will not pollute your project with the configuration files (besides docker-compose.yml and .env).

### PROJECT_ROOT
The path to the root of your project. The default nginx.conf expects a `Web` folder in your project root which is the website root.

### MYSQL_DATABASE
The name of the database that mysql will import the dump into

### MYSQL_USER
The name of the mysql user

### MYSQL_PASSWORD
The password of the mysql user

### MYSQL_ROOT_PASSWORD
The password of the mysql root user

## Fixing permissions
The most important thing here is to set up the proper permissions inside the containers so that nginx can read and php-fpm can read and write files.

You can see your uid and gid by doing `id -u` and `id -g`.

On many systems these values will be `1000`. Now we need to make sure that the PHP process runs as that user and group so it can read and write files in your web directory.

We do this by adding the following lines to the file `/.docker/php/php-fpm.conf`:
```ini
user = 1000
group = 1000
```

This ensure that the PHP-FPM process can read and write files in your project.

The `php-fpm.conf` is re-used for the xdebug and blackfire backend.

The `/.docker/before_script/init.sh` takes care of setting the correct permissions on the `vendor` and `Web` directories so that the nginx process can access them.

## Importing a database
Any files in `/.docker/db/` ending in `tar.gz` or `gz` will be imported.

## Acessing the site by name
Your site will be accessible on `prefix_web_1` and if you specify a hostname also on the specified hostname; `prefix.dev.local` in this case:

## SSL support
Import `.docker/web/ca/cacert.crt` into your browser. Allow it authenticate websites.
This was generated using: https://gist.github.com/jchandra74/36d5f8d0e11960dd8f80260801109ab0

The provided certificates have wildcards for:
* *.dev.local
* *.blackfire.local
* *.bf.local
* *.xdebug.local
* *.xdbg.local

This makes is possible to visit `prefix.dev.local` securely. If you want to use the blackfire php backend, you can visit `prefix.blackfire.local` or `prefix.bf.local`.

## Known issues
Mariadb creates the database with latin1 collation. You can change the collation with the following SQL query on the db instance:
```sql
ALTER DATABASE database_name_here CHARACTER SET utf8 COLLATE utf8_general_ci;
```

From the host:
```bash
docker-compose exec db bash -c 'mysql -u root -psupersecret -e "ALTER DATABASE v8 CHARACTER SET utf8 COLLATE utf8_general_ci;"'
```
