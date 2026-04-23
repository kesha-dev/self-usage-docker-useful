#!/bin/bash

# Скрипт установки Docker и Docker Compose для Ubuntu
echo "=== Начало установки Docker и Docker Compose ==="

# Проверка, что скрипт запущен от sudo
if [ "$EUID" -ne 0 ]; then
    echo "Этот скрипт требует права sudo. Запустите с:"
    echo "sudo bash $0"
    exit 1
fi

# Определение текущего пользователя
CURRENT_USER=$(logname)
if [ -z "$CURRENT_USER" ]; then
    CURRENT_USER=${SUDO_USER:-$USER}
fi

echo "Установка для пользователя: $CURRENT_USER"

# Обновление пакетов
echo "=== Обновление списка пакетов ==="
apt update

# Установка зависимостей
echo "=== Установка зависимостей ==="
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common

# Добавление GPG ключа Docker
echo "=== Добавление GPG ключа Docker ==="
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Добавление репозитория Docker
echo "=== Добавление репозитория Docker ==="
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновление пакетов
echo "=== Обновление пакетов после добавления репозитория ==="
apt update

# Установка Docker
echo "=== Установка Docker ==="
apt install -y docker-ce docker-ce-cli containerd.io

# Запуск и включение автозагрузки Docker
echo "=== Запуск службы Docker ==="
systemctl start docker
systemctl enable docker

# Установка Docker Compose
echo "=== Установка Docker Compose ==="
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Создание симлинка для совместимости
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Добавление пользователя в группу docker
echo "=== Добавление пользователя $CURRENT_USER в группу docker ==="
usermod -aG docker $CURRENT_USER

# Проверка установки
echo "=== Проверка установки ==="
echo "Версия Docker:"
docker --version
echo "Версия Docker Compose:"
docker-compose --version

# Информация для пользователя
echo ""
echo "=== Установка завершена успешно! ==="
echo "Для применения изменений прав выполните ОДНУ из следующих команд:"
echo "1. ПЕРЕЗАГРУЗИТЕ СИСТЕМУ: sudo reboot"
echo "2. Или выполните: newgrp docker"
echo ""
echo "После этого проверьте работу: docker ps"