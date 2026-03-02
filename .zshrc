# Опции истории
setopt APPEND_HISTORY          # Добавлять историю в файл, а не перезаписывать его
setopt SHARE_HISTORY           # Делиться историей между всеми вкладками в реальном времени
setopt HIST_IGNORE_DUPS        # Не сохранять дубликаты (если дважды ввели ls)
setopt HIST_IGNORE_SPACE       # Не сохранять команды, начинающиеся с пробела
setopt HIST_REDUCE_BLANKS      # Удалять лишние пробелы из команд
setopt INC_APPEND_HISTORY      # Записывать команду в файл сразу, не дожидаясь закрытия сессии

# Подтягиваем лимиты (лучше сделать их одинаковыми)
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Определяем стандартные клавиши (Delete, Home, End и т.д.)
bindkey "^[[3~" delete-char

# Скорее всего, Home и End у вас тоже работают странно, 
# так что лучше добавить и их:
bindkey "^[[1;5C" forward-word       # Ctrl + Right
bindkey "^[[1;5D" backward-word      # Ctrl + Left
bindkey "^[[H" beginning-of-line     # Home
bindkey "^[[F" end-of-line           # End

# Функция для проверки Git-статуса
function git_prompt_info() {
  local ref dirty untracked staged unstaged

  # Проверяем, есть ли Git-репозиторий
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return
  fi

  # Имя ветки
  ref=$(git symbolic-ref HEAD 2>/dev/null) || ref="(detached)"
  ref=${ref#refs/heads/}

  # Проверяем статус
  local git_status=$(git status --porcelain 2>/dev/null)

  # Untracked files (?? в статусе)
  if [[ $git_status =~ '^\?\?' ]]; then
    untracked="?"
  fi

  # Unstaged changes (M, D и т.д. во второй колонке)
  if [[ $git_status =~ '^.[MD]' ]]; then
    unstaged="!"
  fi

  # Staged changes (A, M и т.д. в первой колонке)
  if [[ $git_status =~ '^[AMDR].' ]]; then
    staged="*"
  fi

  # Если есть изменения, собираем метки
  dirty="${staged}${unstaged}${untracked}"

  # Вывод: ветка + метки, если есть
  if [[ -n $dirty ]]; then
    echo " (${ref}${dirty})"
  else
    echo " (${ref})"
  fi
}

# Добавляем в prompt (PS1). 
setopt prompt_subst
PROMPT='%(?.%F{#a6e3a1}➜.%F{#f38ba8}➜) %F{#89b4fa}%3~%f$(git_prompt_info) %(!.%F{#f9e2af} [ROOT]%f)'

# Автозагрузка, если нужно (для цвета и т.д.)
autoload -U colors && colors

# --- ПРАВЫЙ ПРОМПТ ---
# %* - текущее время (секунды помогают видеть, когда была запущена команда)
# %? - код возврата последней ошибки (показывается только если он не 0)
RPROMPT="%(?..%F{#f38ba8}exit %?%f) %F{#6c7086}%*%f"

alias ll="eza -l --header --icons --git"
alias la="eza -la --header --icons --git"
alias gitlog="git log --all --decorate --oneline --graph --color"
#alias bat="batcat"
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit -m"
alias -g G='| rg'

export PATH=$PATH:$HOME/.local/bin
export EDITOR=/usr/bin/hx
export PATH=$PATH:$HOME/.cargo/bin
export UV_LINK_MODE=copy


alias hh=hstr                    # hh to be alias for hstr
setopt histignorespace           # skip cmds w/ leading space from history
export HSTR_CONFIG=hicolor       # get more colors
hstr_no_tiocsti() {
     zle -I
     { HSTR_OUT="$( { </dev/tty hstr ${BUFFER}; } 2>&1 1>&3 3>&- )"; } 3>&1;
     BUFFER="${HSTR_OUT}"
     CURSOR=${#BUFFER}
     zle redisplay
}
zle -N hstr_no_tiocsti
bindkey '\C-r' hstr_no_tiocsti
export HSTR_TIOCSTI=n
export HSTR_CONFIG=raw-history-view
export HSTR_CONFIG=hicolor


# Поиск из домашней директории
cdh() { local dir; dir=$(fd --hidden ~ -p ~ --type d 2>/dev/null | fzf +m --preview 'ls -la {} | head -10') && cd "$dir"; }

# Поиск из текущей директории
cdl() { local dir; dir=$(fd --hidden --type d 2>/dev/null | fzf +m --preview 'ls -la {} | head -10') && cd "$dir"; }

### Поиск файла из текущей директории, открыть с помощью редактора
hxl() { local dir; dir=$(fd --hidden --type f 2>/dev/null | fzf +m --preview 'bat {}') && $EDITOR "$dir"; }

### Поиск файла из домашней директории, открыть с помощью редактора
hxh() { local dir; dir=$(fd --hidden ~ -p ~ --type f 2>/dev/null | fzf +m --preview 'bat {}') && $EDITOR "$dir"; }

# Обновить .zshrc
rbs() { source ~/.zshrc; }

# Обновить пакеты
upd() { sudo dnf upgrade --refresh; }

# Генератор пароля
passgen() { date +%s | sha256sum | base64 | head -c 16; echo; }

# Синхронизировать заметки
sync_note() {
  cd ~/mnt/telephone-folder/my_note &&
  git pull &&
  git add -A &&
  git commit -a -m "fedora backup: $(date +'%Y-%m-%d %H:%M:%S')" &&
  git push &&
  echo "Backup OK"
  cd
}

# Backup конфиг файлов
save_config() {
  cp -r ~/.config/{autostart,kitty,nvim,wofi,helix,zellij} ~/mnt/configs 2>/dev/null
  cp ~/.{gitconfig,zshrc,bashrc} ~/mnt/configs 2>/dev/null
  cp ~/.tmux.conf ~/mnt/configs 2>/dev/null
  cp -r ~/.ssh ~/mnt/configs 2>/dev/null
  echo "Configs backed up"
}
### Вывод списка скриптов + описание
fns() {
  local user_funcs=(
    'cdh        # Поиск из домашней директории и переход'
    'cdl        # Поиск из текущей директории и переход'
    'rbs        # source ~/.zshrc'
    'upd        # sudo dnf upgrade'
    'passgen    # Генератор пароля'
    'sync_note  # Git sync заметок'
    'fns        # Этот список'
    'hxl        # Helix - поиск файла из текущей директории и открытие'
    'hxh        # Helix - поиск файла из домашней директории и открытие'
    'tms        # список сессий'
    'tma        # создать или подключиться к сессии'
    'tmk        # убить сессию'
    'tmr        # переименовать сессию'
    'tmn        # создать новую сессию с произвольным именем'
    'venv       # Активация .venv/venv'
    'devenv     # Деактивация venv'
    'venv_status # Статус venv'
    'save_config # Backup конфиг файлов: .config, zsh, tmux etc'
  )
  print -l ${user_funcs} | bat -l zsh
}

# tmux сессии
tms() { tmux ls | bat -l log; }           # список сессий
tma() { tmux attach -t ${1:-main} || tmux new -s main; }  # attach или new
tmk() { tmux kill-session -t ${1:-main}; }  # kill сессии
tmr() { tmux rename-session -t ${1:-main} $2; }           # переименовать
tmn() { tmux new -s ${1};}

venv() {
  local venv_path=""
  
  ### Поиск .venv в текущей/родительских директориях
  if [[ -f .venv/bin/activate ]]; then
    venv_path="./.venv/bin/activate"
  elif [[ -f venv/bin/activate ]]; then
    venv_path="./venv/bin/activate"
  else
    # Ищем вверх по дереву
    local dir=$(pwd)
    while [[ $dir != "/" ]]; do
      if [[ -f "$dir/.venv/bin/activate" ]]; then
        venv_path="$dir/.venv/bin/activate"
        break
      fi
      dir=$(dirname "$dir")
    done
  fi
  
  if [[ -n $venv_path ]]; then
    source "$venv_path"
    echo "✅ venv активировано: $(basename $(dirname $venv_path))"
    which python pip  # показываем пути
  else
    echo "❌ .venv не найден. Создать? (uv venv)"
    read -q && uv venv --seed && source .venv/bin/activate
  fi
}

### Деактивация
devenv() { deactivate 2>/dev/null && echo "✅ venv деактивировано"; }

### Проверка статуса
venv_status() {
  if [[ -n $VIRTUAL_ENV ]]; then
    echo "🟢 venv: $(basename $VIRTUAL_ENV)"
    which python pip
  else
    echo "🔴 venv не активно"
  fi
}


# Для подключения дополнений, создана директория .zsh
# Подключение подсказок из уже вводимых ранее команд
# git clone https://github.com/zsh-users/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'

# Подключение подсветка
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Настройка, чтобы при tab открывалось меню
# Для докера добавляем путь к дополнению
# curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker > ~/.zsh/completions/_docker 
fpath=(~/.zsh/completions $fpath)

# Включаем современную систему дополнений
autoload -Uz compinit && compinit

# 1. Включаем интерактивное меню выбора
zstyle ':completion:*' menu select

# 2. Подтягиваем цвета из ваших системных настроек (LS_COLORS)
# Это заставит меню выглядеть так же, как вывод команды ls
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# 3. Группировка результатов (отдельно папки, отдельно файлы)
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#f9e2af}--- %d ---%f'

# 4. Умный поиск: игнорировать регистр и позволять исправлять опечатки
zstyle ':completion:*' matcher-list 'm:{a-z A-Z}={A-Z a-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Не справшивать разрешения при выводе большого списка
LISTMAX=0

# Умный kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes' command 'ps -au$USER'

# Группировка для Docker: отдельно команды, отдельно контейнеры и образы
zstyle ':completion:*:*:docker:*' group-name ''
zstyle ':completion:*:*:docker-*:*' group-name ''

# Описания для разделов (будет красиво написано "containers", "images" и т.д.)
zstyle ':completion:*:*:docker:*:descriptions' format '%F{#f9e2af}--- %d ---%f'
zstyle ':completion:*:*:docker-*:*:descriptions' format '%F{#f9e2af}--- %d ---%f'

# Разрешаем "склеивание" коротких флагов (например, -it)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
