#!/usr/bin/env zsh
# Аргумент: путь к директории
dir="$1"

# Проверяем, есть ли Git-репозиторий
if ! git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null; then
  exit 0
fi

# Имя ветки
ref=$(git -C "$dir" symbolic-ref HEAD 2>/dev/null) || ref="(detached)"
ref=${ref#refs/heads/}

# Проверяем статус
git_status=$(git -C "$dir" status --porcelain 2>/dev/null)

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
