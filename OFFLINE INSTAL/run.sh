#!/bin/bash

# Путь к npos-api скрипту
SCRIPT_PATH="$HOME/wildberries/offline/npos-api/npos-api"
# Путь к лог файлу для вывода
LOG_FILE="/tmp/npos-api.log"

install_offline() {
    echo "Устанавливаем Офлайн..."
    wget --no-check-certificate https://static-basket-02.wbbasket.ru/vol24/branch_office_apps/offline-plus/linux_install.sh
    chmod +x linux_install.sh
    ./linux_install.sh
    echo "Установка завершена."
}

update_offline() {
    echo "Обновляем Офлайн..."
    set -e  # Оставляем только -e, убираем -x для выключения отладки
    mkdir -p ~/wildberries/offline
    wget --no-check-certificate https://static-basket-02.wbbasket.ru/vol24/branch_office_apps/offline-plus/latest.tar.gz -O /tmp/latest.tar.gz
    tar -xzf /tmp/latest.tar.gz -C ~/wildberries/offline
    rm -rf /tmp/latest.tar.gz*
    killall -q npos-api || true
    start
    echo "Обновление завершено."
}

start() {
    if pgrep -f "$SCRIPT_PATH" > /dev/null; then
        echo "Офлайн уже запущен."
    else
        if [ ! -f "$SCRIPT_PATH" ]; then
            echo "Офлайн не найден по пути $SCRIPT_PATH."
            install_offline
        fi

        echo "Запускаем Офлайн в фоновом режиме..."
        nohup $SCRIPT_PATH > "$LOG_FILE" 2>&1 &
        sleep 2  # Пауза, чтобы процесс успел запуститься
        if pgrep -f "$SCRIPT_PATH" > /dev/null; then
            echo "Офлайн запущен в фоновом режиме."
        else
            echo "Ошибка: не удалось запустить Офлайн."
        fi
    fi
}

status() {
    if pgrep -f "$SCRIPT_PATH" > /dev/null; then
        echo "Офлайн запущен."
    else
        echo "Офлайн не работает."
    fi
}

stop() {
    echo "Останавливаем все процессы npos-api..."
    killall -q npos-api || true
    echo "Офлайн остановлен."
}

restart() {
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
            echo "Выход..."
            exit 0
            ;;
        *)
            echo "Неверный выбор. Попробуйте снова."
            ;;
    esac
    echo  
done

