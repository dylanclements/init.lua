-- set leader to the space bar
vim.g.mapleader = " "

-- nvim tree settings
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>")

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
-- vim.keymap.set("x", "<leader>p", [["_dP]])

-- paste from the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]]);

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
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true });

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
vim.keymap.set("n", "<leader>vt", ":vsplit | terminal<CR><C-w>L", { silent = true });

-- go to next/previous buffer
vim.keymap.set("n", "<leader>n", ":bn<CR>");
vim.keymap.set("n", "<leader>b", ":bp<CR>");
vim.keymap.set("n", "<leader>ls", ":ls<CR>");

-- resize windows
vim.keymap.set("n", "=", [[<cmd>vertical resize -5<cr>]])   -- make the window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize +5<cr>]])   -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -k

-- make all window sizes equal
vim.keymap.set("n", "<leader>=", function()
    -- Get the number of windows
    local num_windows = vim.fn.winnr('$')
    
    if num_windows > 1 then
        -- Calculate equal width
        local total_width = vim.o.columns
        local equal_width = math.floor(total_width / num_windows)
        
        -- Store current window
        local current_win = vim.api.nvim_get_current_win()
        
        -- Resize each window
        for i = 1, num_windows do
            local win_id = vim.fn.win_getid(i)
            vim.api.nvim_win_set_width(win_id, equal_width)
        end
        
        -- Return focus to original window
        vim.api.nvim_set_current_win(current_win)
        
        vim.notify(string.format("Resized %d windows to equal width", num_windows), vim.log.levels.INFO)
    else
        vim.notify("Only one window open", vim.log.levels.INFO)
    end
end, { desc = "Make all windows equal width" })

-- python
vim.keymap.set("n", "<leader>py", ":!python %<CR>")

vim.keymap.set("n", "<leader>ts", function()
    vim.fn.system("tmux switch -t terminal")
end)

-- LSP toggle for current buffer
vim.keymap.set("n", "<leader>lt", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    
    if #clients > 0 then
        -- LSP is active, detach all clients from this buffer
        for _, client in pairs(clients) do
            vim.lsp.buf_detach_client(bufnr, client.id)
        end
        vim.notify("LSP disabled for current buffer", vim.log.levels.INFO)
    else
        -- LSP is inactive, reattach by triggering LSP setup
        vim.cmd("LspStart")
        vim.notify("LSP enabled for current buffer", vim.log.levels.INFO)
    end
end, { desc = "Toggle LSP for current buffer" })
