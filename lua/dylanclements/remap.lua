-- set leader to the space bar
vim.g.mapleader = " "

-- nvim tree settings
vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>pt", ":NvimTreeFindFile<CR>")

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
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete to the black hole register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- another way to escape
vim.keymap.set("i", "<C-c>", "<Esc>")

-- no-op Q because it may conflict with exiting or something idk
vim.keymap.set("n", "Q", "<nop>")

-- some tmux thing, not sure if this is needed
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux new tmux-sessionizer<CR>")

-- formatting
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- move to next/prev item in vim quickfix list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- move to next/prev item in the location list
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- search
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- grand executable permission to file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- go to packer.lua
-- vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/dylanclements/packer.lua<CR>");

-- cosmetic animations
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");
vim.keymap.set("n", "<leader>gl", "<cmd>CellularAutomaton game_of_life<CR>");

-- increase the width of windows
vim.keymap.set("n", "<leader>>", "5<C-W>>");
vim.keymap.set("n", "<leader><", "5<C-W><");

-- exit terminal buffer and enter normal mode
vim.keymap.set("t", "<C-w>n", "<C-\\><C-n>");

-- go to next/previous buffer
vim.keymap.set("n", "<leader>n", ":bn<CR>");
vim.keymap.set("n", "<leader>b", ":bp<CR>");
vim.keymap.set("n", "<leader>ls", ":ls<CR>");

-- resize windows
vim.keymap.set("n", "=", [[<cmd>vertical resize -5<cr>]]) -- make the window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize +5<cr>]]) -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -k

-- move to different windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
