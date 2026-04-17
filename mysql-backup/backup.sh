#!/bin/bash
set -e

export $(grep -v '^#' .env | xargs)

: "${DB_HOST?DB_HOST не задан}"
: "${DB_PORT?DB_PORT не задан}"
: "${DB_USER?DB_USER не задан}"
: "${DB_PASSWORD?DB_PASSWORD не задан}"
: "${DB_NAME?DB_NAME не задан}"
: "${BACKUP_FILENAME?BACKUP_FILENAME не задан}"

mkdir -p /backup
TIMESTAMP=$(date +"${BACKUP_FILENAME}")
BACKUP_PATH="/backup/${TIMESTAMP}"

echo "База: '${DB_NAME}'. Хост: ${DB_HOST}:${DB_PORT}"

mysqldump \
  --single-transaction \
  --skip-flush-privileges \
  --skip-lock-tables \
  --set-gtid-purged=OFF \
  -h "${DB_HOST}" \
  -P "${DB_PORT}" \
  -u "${DB_USER}" \
  --password="${DB_PASSWORD}" \
  "${DB_NAME}" > "${BACKUP_PATH}"

echo "Дамп успешно создан"
ls -lh "${BACKUP_PATH}"