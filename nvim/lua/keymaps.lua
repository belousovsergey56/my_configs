-- Базовые маппинги
vim.g.mapleader = ' ' -- Leader-клавиша (пробел)
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Сохранить файл
map('n', '<C-s>', ':w<CR>', opts)

-- Открыть/закрыть NvimTree
map('n', '<F1>', ':NvimTreeToggle<CR>', opts)

-- Открыть/закрыть терминал
map('t', '<F3>', '<C-\\><C-n>:TermToggle<CR>', opts)

-- Перемещение строк
map('n', '<C-S-Up>', ':move -2<CR>', opts)
map('n', '<C-S-Down>', ':move +1<CR>', opts)

-- Для визуального режима
map('v', '<C-S-Up>', ":move '<-2<CR>gv=gv", opts)
map('v', '<C-S-Down>', ":move '>+1<CR>gv=gv", opts)


-- запуск текущего файла
local function run_current_file()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    print("Файл не сохранён")
    return
  end

  -- Отладка: вывод текущего пути
  print("Current buffer name: " .. bufname)

  local ext = bufname:match("%.([^%.]*)$") or ""
  local dir = vim.fn.fnamemodify(bufname, ":p:h") -- Полный путь к директории
  local filename = vim.fn.fnamemodify(bufname, ":t:r") -- Имя файла без расширения

  -- Отладка: вывод переменных
  print("Extension: " .. ext)
  print("Directory: " .. dir)
  print("Filename: " .. filename)

  local cmd = ""

  if ext == "py" then
    -- Для Python: cd директория && python3 -m имя_файла
    cmd = string.format("uv run %s.py", filename)
  elseif ext == "js" then
    -- Для JavaScript: cd директория && node имя_файла.js
    cmd = string.format("cd '%s' && node '%s'", dir, bufname)
  else
    print("Неподдерживаемый формат файла: ." .. ext)
    return
  end

  -- Отладка: вывод сформированной команды
  print("Выполняемая команда: " .. cmd)

  -- Выполняем команду в терминале
  vim.cmd("TermExec cmd='" .. cmd .. "'")
end

-- Назначаем F9 на запуск
vim.keymap.set("n", "<F9>", run_current_file, { noremap = true, silent = true })


