return {
  "folke/which-key.nvim",
  opts = {
    plugins = {
      registers = true, -- keep hints for "
      spelling = { enabled = true },
      presets = {
        operators = false, -- disable which-key for g, d, c, y, etc.
        motions = false,
        text_objects = false,
      },
    },
    delay = 0,
  },
}
