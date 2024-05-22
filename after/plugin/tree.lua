-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
-- already set to true in set.lua but its here in case that changes
-- vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = {
        min = 30,
        max = -1,
        padding = 1
    }
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})