#!/bin/zsh

# --- Вспомогательные функции ---

_ask_step() {
    echo -e "\n\e[1;34m>>> ШАГ: $1\e[0m"
    echo -n "Выполнить? [y]es / [n]ext / [q]uit: "
    read -k 1 res
    echo ""
    case $res in
        [Yy$'\n']) return 0 ;;
        [Qq]) echo "Выход..."; exit 0 ;;
        *) return 1 ;;
    esac
}

# --- Функции шагов ---

step_fstab() {
    echo "=== Шаг 1: Монтирование дисков ==="
    echo "Подключи в /mnt общий с Windows раздел вручную."
    echo "Затем добавь в /etc/fstab следующие строки:"
    echo ""
    echo "UUID=209472BF9472974E /home/belousov/win ntfs-3g uid=1000,gid=1000,dmask=0002,fmask=0111,locale=ru_RU.UTF-8 0 0"
    echo "UUID=09d31e15-2dfc-4dbb-b9db-dbfb70fc0c33 /home/belousov/mnt ext4 defaults 0 1"

}

step_dnf_speed() {
    echo "Настройка /etc/dnf/dnf.conf для ускорения..."
    sudo tee /etc/dnf/dnf.conf <<EOF
[main]
gpgcheck=True
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
max_parallel_downloads=15
keepcache=1
fastestmirror=True
EOF
}

step_install_apps() {
    echo "Обновляем систему..."
    sudo dnf5 check-update
    sudo dnf5 update -y
    
    local apps=(cargo helix kitty tmux htop wofi translate-shell fzf breeze-cursor-theme zsh git util-linux-user fd-find duf bat eza hstr fastfetch tldr python3-pip gnome-tweaks)

    echo "Устанавливаем программы..."
    for app in "${apps[@]}"; do
        sudo dnf5 install $app -y || echo "!!! $app не найден в репозиторияh"
    done

    echo "Устанавливаем ptpython и bpython через pip..."
    pip3 install --user ptpython || echo "ptpython не установлен"
    pip3 install --user bpython || echo "bpython не установлен"
}

step_configs() {
    echo "Копирование конфигов..."
    mkdir -p ~/.config ~/.local/myscripts
    cp -r ~/mnt/configs/{autostart,helix,kitty,wofi} ~/.config 2>/dev/null
    cp -r ~/mnt/configs/.{ssh,zsh} ~/ 2>/dev/null
    cp ~/mnt/configs/.{gitconfig,tmux.conf,zshrc} ~/ 2>/dev/null
    cp -r ~/mnt/configs/myscripts ~/.local/ 2>/dev/null
}

step_icons() {
    echo "Установка иконок Kora..."
    git clone https://github.com/bikass/kora.git ~/kora_tmp
    mkdir -p ~/.local/share/icons
    sudo cp -r ~/kora_tmp/kora* /usr/share/icons/
    cp -r ~/kora_tmp/kora* ~/.local/share/icons/
    rm -rf ~/kora_tmp
}

step_links() {
    echo "Создание симлинков на папки данных..."
    for dir in Documents Music Pictures; do
        rm -rf "/home/$USER/$dir"
        ln -s "$HOME/mnt/$dir" "$HOME/$dir"
    done
    ln -s ~/mnt/code ~/code
}

step_flatpak() {
    local fp_apps=(
        com.mattjakeman.ExtensionManager
        io.dbeaver.DBeaverCommunity
        md.obsidian.Obsidian
        org.keepassxc.KeePassXC
    )
    for app in "${fp_apps[@]}"; do
        flatpak install flathub $app -y
    done
}

show_hotkeys() {
    echo -e "\n\e[1;32m#############################################"
    echo "СПРАВКА ПО ГОРЯЧИМ КЛАВИШАМ (GNOME):"
        echo "Шаблон для wofi:"
    echo "   wofi --show drun"
    echo ""
    echo "Рекомендуемые привязки:"
    echo "• F12               → tilix"
    echo "• Super + F12       → settings"
    echo "• browser bind      → vivaldi"
    echo "• Super + E         → file manager"
    echo "• calc bind         → calc"
    echo "• Caps Lock         → change layout"
    echo "• Super + Space     → wofi"
    echo "• Ctrl + Super + →  → move to workspace right"
    echo "• Ctrl + Super + ←  → move to workspace left"
    echo "• Shift + Super + → → move window right"
    echo "• Shift + Super + ← → move window left"
    echo "• Alt + Tab         → switch windows"
    echo "• Super + D         → Hide all normal windows"
    echo ""
    echo "Расширения:"
    echo "• Установи Just Perfection"
    echo "• Extension Manager (уже в flatpak выше)"
    echo ""
    echo "Дополнительно:"
    echo "1. После установки zsh выполни:"
    echo "   chsh -s \$(which zsh)"
    echo "2. Перезагрузись или выполни source ~/.zshrc"
    echo ""
    echo "##############################################\e[0m"
}

# --- Главная функция ---

setup_system() {
    _ask_step "Ускорить DNF (dnf.conf)" && step_dnf_speed
    _ask_step "Монтирование дисков (fstab)" && step_fstab
    _ask_step "Обновление и установка программ (DNF/Pip)" && step_install_apps
    _ask_step "Копирование конфиг-файлов" && step_configs
    _ask_step "Установка иконок Kora" && step_icons
    _ask_step "Создание ссылок на Documents/Music/Code" && step_links
    _ask_step "Установка Flatpak пакетов" && step_flatpak

    echo -e "\n\e[1;33mНастройка завершена!\e[0m"
    show_hotkeys
}

# Запуск функции
setup_system
