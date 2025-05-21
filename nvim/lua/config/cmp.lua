-- lua/config/cmp.lua
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),  -- Основное сочетание
    ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Подтверждение выбора
    ['<Tab>'] = cmp.mapping.select_next_item(),  -- Навигация
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },   -- Данные от LSP (pyright)
    { name = 'luasnip' },    -- Сниппеты
    { name = 'buffer' },     -- Текущий буфер
    { name = 'path' },       -- Пути файлов
  })
})

-- Подключение LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Обновите настройки LSP серверов (например, pyright):
require('lspconfig').pyright.setup({
  capabilities = capabilities,
  -- остальные настройки...
})
