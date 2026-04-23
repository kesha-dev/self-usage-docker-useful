#!/bin/bash

apt-get update && apt-get upgrade -y \
&& apt-get install -y --no-install-recommends apt-utils curl \
&& install-php-extensions \
    zip gd pdo_mysql opcache intl \
    mysqli soap fileinfo bz2 imagick imap sockets \
&& apt-get autoremove --purge -y \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*