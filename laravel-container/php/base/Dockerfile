# Определяем переменную MODE (по умолчанию 'cli')
ARG PHP_VERSION=8.4
ARG PHP_MODE=cli

# Выбираем базовый образ на основе MODE
FROM php:${PHP_VERSION}-${PHP_MODE}

# Общие шаги для всех режимов

# Утилиты для установки расширений и Composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Настройка пользователя (совместимость с хостом)
ARG PUID=1001
ARG PGID=1001
RUN groupadd -g ${PGID} app && \
    useradd -u ${PUID} -g app -m app && \
    usermod -p "*" app -s /bin/bash

# Основные расширения PHP
COPY ./php/base/common-packages.sh /tmp/
RUN chmod +x /tmp/common-packages.sh && \
    /tmp/common-packages.sh

# Рабочая директория
WORKDIR /var/www/app

# Создаем необходимые директории и настраиваем права
RUN mkdir /var/www/app/vendor && \
    chown -R app:app /var/www/app

# Переключаемся на пользователя app
USER app
