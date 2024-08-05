#!/bin/bash

# Создаём папку для распаковки архива
DEST_DIR="$HOME/NPOS-API-Control"
mkdir -p "$DEST_DIR"

# Скачиваем архив в /tmp
ARCHIVE_URL="https://github.com/pvzchekmeneva20/NPOS-API-Control/releases/download/Publish/Last.7z"
ARCHIVE_PATH="/tmp/Last.7z"
wget "$ARCHIVE_URL" -O "$ARCHIVE_PATH"

# Распаковываем архив в созданную папку
7z x "$ARCHIVE_PATH" -o"$DEST_DIR"

# Удаляем скачанный архив
rm -rf "$ARCHIVE_PATH"

# Переходим в распакованную папку
cd "$DEST_DIR"

# Делаем скрипт install.sh исполняемым
chmod +x install.sh

# Запускаем скрипт install.sh
./install.sh
