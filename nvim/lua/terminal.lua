require("toggleterm").setup({
  size = 20,                   -- Высота терминала
  open_mapping = [[<F3>]],    -- Открытие/закрытие на F3
  direction = "horizontal",   -- Горизонтальное расположение
  float_opts = {
    border = "curved",         -- Рамка вокруг терминала
  },
})
