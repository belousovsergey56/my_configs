-- duplicate line -- 
-- В любом Lua-файле конфигурации (например, lua/config/mappings.lua)
vim.g.duplicate_line = function()
  local line = vim.api.nvim_get_current_line()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, true, { line })
end

-- Normal mode
vim.keymap.set('n', '<C-d>', vim.g.duplicate_line, { noremap = true, silent = true })

-- Insert mode (с возвратом в режим вставки)
vim.keymap.set('i', '<C-d>', '<Esc>:lua vim.g.duplicate_line()<CR>gi', { noremap = true, silent = true })

