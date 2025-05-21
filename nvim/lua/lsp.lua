-- lua/config/lsp.lua
local mason = require('mason')
local mason_lsp = require('mason-lspconfig')
local lspconfig = require('lspconfig')

-- Включить виртуальный текст с ошибками
vim.diagnostic.config({
  virtual_text = true,          -- Текст ошибок рядом с кодом
  underline = true,             -- Подчёркивание ошибок
  signs = true,                 -- Значки на полях (⚠️, ❗)
  update_in_insert = false,     -- Не обновлять во время ввода
  severity_sort = true,         -- Сортировать ошибки по важности
})

-- Инициализация Mason
mason.setup()
mason_lsp.setup({
  ensure_installed = { 'pyright' }  -- Автоматическая установка pyright
})

-- Общая конфигурация LSP
local on_attach = function(client, bufnr)
  -- Горячие клавиши только для буфера с LSP
  local opts = { noremap = true, silent = true, buffer = bufnr }

-- Новые горячие клавиши для диагностики
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)  -- Показать ошибку
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts) -- Список ошибок

  -- Включение подсказки (сигнатуры функции)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- Конфигурация для pyright
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true
      }
    }
  }
})
