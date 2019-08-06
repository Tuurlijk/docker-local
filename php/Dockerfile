FROM php:7.3-fpm

# create users and groups for most common default uids
RUN set -x \
    && if ! getent group dev; then groupadd -g 1000 -r dev; \
    useradd -u 1000 -m -s /bin/bash -g dev dev -d /var/www/html; fi \
    && if ! getent group docker; then groupadd -g 501 -r docker; \
    useradd -u 501 -m -s /bin/bash -g docker docker -d /var/www/html; fi

RUN apt-get update \
    && apt-get install -y \
        graphicsmagick \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmagickwand-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        mariadb-client \
        rsync \
        vim \
        zsh \
        --no-install-recommends

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

RUN curl -L https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 -o mhsendmail_linux_amd64 \
    && chmod +x mhsendmail_linux_amd64 \
    && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail \
    && chsh root -s /bin/zsh

RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) bz2 \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) opcache \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) soap \
    && docker-php-ext-install -j$(nproc) zip \
    && yes | pecl install imagick \
    && docker-php-ext-enable imagick

## Cleanup dev libs and headers
RUN apt-get autoremove --purge -y

RUN yes | pecl install igbinary \
    && docker-php-ext-enable igbinary

RUN yes | pecl install redis \
    && docker-php-ext-enable redis

RUN apt-get update \
    && apt-get install -y \
        git \
        unzip \
        --no-install-recommends

