-- lua/config/autopairs.lua
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  disable_in_macro = true,  -- Не работать при записи макросов
  enable_check_bracket_line = false,  -- Не проверять текущую строку
  ignored_next_char = "[%w%.]", -- Игнорировать если следующий символ буква/цифра/точка
  check_ts = true, -- Использовать treesitter
})
