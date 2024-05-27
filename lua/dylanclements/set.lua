vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.tabstop = 4           -- Number of spaces a tab in the file counts for
vim.opt.shiftwidth = 4        -- Number of spaces to use for each step of (auto)indent
vim.opt.softtabstop = 4       -- Number of spaces that a <Tab> or <BS> counts for while performing editing operations like insert, delete and join

vim.opt.number = true         -- Enable absolute line numbers
vim.opt.relativenumber = true -- Enable relative line numbers

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

