require("nvim-tree").setup({
  view = {
    side = "right", -- Сайдбар справа
    width = 30,     -- Ширина
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "", -- Иконка закрытой папки
          arrow_open = "",   -- Иконка открытой папки
        },
      },
    },
  },
  filters = {
    dotfiles = false, -- Не скрывать .файлы
  },
})
