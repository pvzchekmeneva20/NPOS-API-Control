#!/bin/bash

# Путь к папке назначения для скрипта run.sh
DEST_SCRIPT="$HOME/run.sh"

# Автоматическое определение пути к рабочему столу
DESKTOP_DIR=$(xdg-user-dir DESKTOP)

# Путь к дескриптору на рабочем столе
DEST_DESKTOP="$DESKTOP_DIR/npos-api-control.desktop"

# Создаём папки и копируем файлы
echo "Копируем run.sh в $DEST_SCRIPT..."
cp run.sh "$DEST_SCRIPT"
chmod +x "$DEST_SCRIPT"

echo "Копируем npos-api-control.desktop на рабочий стол..."
cp npos-api-control.desktop "$DEST_DESKTOP"
chmod +x "$DEST_DESKTOP"

echo "Установка завершена!"
