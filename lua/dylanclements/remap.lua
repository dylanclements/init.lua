-- set leader to the space bar
vim.g.mapleader = " "

-- to exit the currrent buffer into netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- In visual mode, move the highlighted text up or down with J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- ctrl-d / ctrl-u in normal mode to move the cursor up and down the file
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- join next line with current but move the cursor back to origin
vim.keymap.set("n", "J", "mzJ`z")

-- centre the cursor after searching for text, open and closed folds
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- [
-- replace the visual selection with the default register 
-- contents without altering the default register
-- ]
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to the system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/dylanclements/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");
vim.keymap.set("n", "<leader>gl", "<cmd>CellularAutomaton game_of_life<CR>");

vim.keymap.set("n", "<leader>>", "5<C-W>>");
vim.keymap.set("n", "<leader><", "5<C-W><");

-- exit terminal buffer and enter normal mode
vim.keymap.set("t", "<C-w>n", "<C-\\><C-n>");

vim.keymap.set("n", "<leader>pr", ":!yarn prettier --write .");
