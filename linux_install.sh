#!/bin/bash

# Скачиваем архив в /tmp
ARCHIVE_URL="https://github.com/pvzchekmeneva20/NPOS-API-Control/releases/download/Publish/Last.7z"
ARCHIVE_PATH="/tmp/Last.7z"
wget "$ARCHIVE_URL" -O "$ARCHIVE_PATH"

# Распаковываем архив в домашнюю директорию пользователя
7z x "$ARCHIVE_PATH" -o"$HOME"

# Удаляем скачанный архив
rm -rf "$ARCHIVE_PATH"

# Переходим в распакованную папку OFFLINE INSTAL
cd "$HOME/OFFLINE INSTAL"

# Делаем скрипт install.sh исполняемым
chmod +x install.sh

# Запускаем скрипт install.sh
./install.sh

