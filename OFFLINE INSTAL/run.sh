#!/bin/bash

# Путь к npos-api скрипту
SCRIPT_PATH="$HOME/wildberries/offline/npos-api/npos-api"
# Путь к лог файлу для вывода
LOG_FILE="/tmp/npos-api.log"
# Цвета для вывода сообщений
GREEN='\033[0;32m'
NC='\033[0m' # ВЫКЛ

install_offline() {
    echo "Устанавливаем Офлайн..."
    wget --no-check-certificate https://static-basket-02.wbbasket.ru/vol24/branch_office_apps/offline-plus/linux_install.sh
    chmod +x linux_install.sh
    ./linux_install.sh
    rm -f linux_install.sh  # Удаляем установочный скрипт 
    echo -e "${GREEN}Установка завершена.${NC}"
}

update_offline() {
    clear
    echo "Обновляем Офлайн..."
    set -e
    mkdir -p ~/wildberries/offline
    wget --no-check-certificate https://static-basket-02.wbbasket.ru/vol24/branch_office_apps/offline-plus/latest.tar.gz -O /tmp/latest.tar.gz
    tar -xzf /tmp/latest.tar.gz -C ~/wildberries/offline
    rm -rf /tmp/latest.tar.gz*
    killall -q npos-api || true
    start
    echo -e "${GREEN}Обновление завершено.${NC}"
}

start() {
    if pgrep -f "$SCRIPT_PATH" > /dev/null; then
        clear
        echo -e "${GREEN}Офлайн уже запущен.${NC}"
    else
        if [ ! -f "$SCRIPT_PATH" ]; then
            clear
            echo "Офлайн не найден по пути $SCRIPT_PATH."
            install_offline
        fi

        clear
        echo "Запускаем Офлайн в фоновом режиме..."
        nohup $SCRIPT_PATH > "$LOG_FILE" 2>&1 &
        sleep 2
        if pgrep -f "$SCRIPT_PATH" > /dev/null; then
            clear
            echo -e "${GREEN}Офлайн запущен в фоновом режиме.${NC}"
        else
            clear
            echo "Ошибка: не удалось запустить Офлайн."
        fi
    fi
}

status() {
    clear
    if pgrep -f "$SCRIPT_PATH" > /dev/null; then
        echo -e "${GREEN}Офлайн запущен.${NC}"
    else
        echo "Офлайн не работает."
    fi
}

stop() {
    clear
    echo "Останавливаем все процессы npos-api..."
    killall -q npos-api || true
    echo -e "${GREEN}Офлайн остановлен.${NC}"
}

restart() {
    clear
    echo "Перезапуск Офлайн..."
    stop
    start
}

show_menu() {
    echo "Управление Офлайн:"
    echo "1) Запустить Офлайн"
    echo "2) Проверить статус Офлайн"
    echo "3) Остановить Офлайн"
    echo "4) Перезапустить Офлайн"
    echo "5) Обновить Офлайн"
    echo "6) Выйти"
    echo -n "Выберите опцию: "
}

while true; do
    show_menu
    read -r choice
    case "$choice" in
        1)
            start
            ;;
        2)
            status
            ;;
        3)
            stop
            ;;
        4)
            restart
            ;;
        5)
            update_offline
            ;;
        6)
            clear
            echo "Выход..."
            exit 0
            ;;
        *)
            clear
            echo "Неверный выбор. Попробуйте снова."
            ;;
    esac
    echo
done
