require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Сам менеджер плагинов
  use 'neovim/nvim-lspconfig'   -- LSP-серверы
  use 'williamboman/mason.nvim' -- Установка LSP серверов
  use 'williamboman/mason-lspconfig.nvim' -- Интеграция Mason + LSP
  use 'nvim-lualine/lualine.nvim' -- Строка статуса
  use 'nvim-treesitter/nvim-treesitter' -- Подсветка синтаксиса
  use 'kyazdani42/nvim-tree.lua' -- Файловый менеджер (сайдбар)
  use 'akinsho/toggleterm.nvim' -- Терминал
  use 'gruvbox-community/gruvbox' -- Тема оформления
  use 'hrsh7th/nvim-cmp'         -- Автодополнение
  use 'hrsh7th/cmp-nvim-lsp'     -- Источник для LSP
  use 'hrsh7th/cmp-buffer'       -- Дополнение из текущего буфера
  use 'hrsh7th/cmp-path'         -- Дополнение путей
  use 'L3MON4D3/LuaSnip'         -- Сниппеты
  use {
  'numToStr/Comment.nvim', -- Комментирование
  config = function()
    require('Comment').setup()
  end
}
  use {
    "windwp/nvim-autopairs",
    config = function()
        require("nvim-autopairs").setup {}
    end
}
use {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lspconfig'},{'nvim-lua/plenary.nvim'}, {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'} }
}

end)


-- Загрузите остальные настройки из отдельных файлов
require('config.cmp')
require('colorscheme')
require('keymaps')
require('lsp')
require('terminal')
require('tree')
require('treesitter')
require('comment')
require('mapping')
require('telescope')


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true

-- Настройки табуляции
vim.opt.tabstop = 4       -- 1 таб = 4 пробела (визуальная ширина)
vim.opt.shiftwidth = 4    -- Автоотступ = 4 пробела
vim.opt.softtabstop = 4   -- "Мягкие" табы (Backspace удаляет 4 пробела)
vim.opt.expandtab = true  -- Преобразовывать табы в пробелы
