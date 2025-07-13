-- set leader to the space bar
vim.g.mapleader = " "

-- nvim tree settings
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-- resize nvim-tree to fit content
vim.keymap.set("n", "<leader>tr", function()
    -- Check if nvim-tree is open
    local tree_exists = pcall(require, "nvim-tree")
    if tree_exists then
        local tree_api = require("nvim-tree.api")
        local tree_view = require("nvim-tree.view")

        if tree_view.is_visible() then
            -- Get the tree window
            local tree_win = tree_view.get_winnr()
            if tree_win then
                -- Find the longest line in the tree buffer
                local tree_buf = vim.fn.bufnr("NvimTree_" .. vim.fn.tabpagenr())
                if tree_buf ~= -1 then
                    local lines = vim.api.nvim_buf_get_lines(tree_buf, 0, -1, false)
                    local max_width = 0

                    for _, line in ipairs(lines) do
                        local line_width = vim.fn.strdisplaywidth(line)
                        if line_width > max_width then
                            max_width = line_width
                        end
                    end

                    -- Add some padding and set the width
                    local new_width = math.min(max_width + 5, vim.o.columns - 10)
                    vim.api.nvim_win_set_width(tree_win, new_width)

                    vim.notify("Resized nvim-tree to fit content", vim.log.levels.INFO)
                end
            end
        else
            vim.notify("NvimTree is not open", vim.log.levels.INFO)
        end
    else
        vim.notify("NvimTree not available", vim.log.levels.INFO)
    end
end, { desc = "Resize nvim-tree to fit content" })

-- In visual mode, move the highlighted text up or down with J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move visual selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move visual selection up" })

-- ctrl-d / ctrl-u in normal mode to move the cursor up and down the file
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down half page and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up half page and center" })

-- join next line with current but move the cursor back to origin
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join next line and keep cursor position" })

-- centre the cursor after searching for text, open and closed folds
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- [
-- replace the visual selection with the default register
-- contents without altering the default register
-- ]
-- vim.keymap.set("x", "<leader>p", [["_dP]])

-- paste from the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" });

-- yank to the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- delete to the black hole register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole register" })

-- another way to escape
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode" })

-- no-op Q because it may conflict with exiting or something idk
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q key" })

-- some tmux thing, not sure if this is needed
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux new tmux-sessionizer<CR>")



-- move to next/prev item in vim quickfix list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })

-- move to next/prev item in the location list
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

-- search
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace word under cursor" })

-- grant executable permission to file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" });

-- go to packer.lua
-- vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/dylanclements/packer.lua<CR>");

-- cosmetic animations
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain animation" });
vim.keymap.set("n", "<leader>gl", "<cmd>CellularAutomaton game_of_life<CR>", { desc = "Game of life animation" });

-- increase the width of windows
vim.keymap.set("n", "<leader>>", "5<C-W>>", { desc = "Increase window width" });
vim.keymap.set("n", "<leader><", "5<C-W><", { desc = "Decrease window width" });

-- exit terminal buffer and enter normal mode
vim.keymap.set("t", "<C-w>n", "<C-\\><C-n>", { desc = "Exit terminal to normal mode" });
vim.keymap.set("n", "<leader>vt", ":vsplit | terminal<CR><C-w>L", { silent = true, desc = "Open terminal in vertical split" });

-- list what's changed
vim.keymap.set("n", "<leader>ls", ":ls<CR>", { desc = "List buffers" });

-- resize windows
vim.keymap.set("n", "=", [[<cmd>vertical resize -5<cr>]], { desc = "Increase window width" })   -- make the window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize +5<cr>]], { desc = "Decrease window width" })   -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "Increase window height" }) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], { desc = "Decrease window height" }) -- make the window smaller horizontally by pressing shift and -k

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
vim.keymap.set("n", "<leader>py", ":!python %<CR>", { desc = "Run Python file" })

-- Bazel build system
vim.keymap.set("n", "<leader>bb", function()
    require("dylanclements.bazel").run_bazel_build()
end, { desc = "Run Bazel build for current target" })

vim.keymap.set("n", "<leader>bl", function()
    require("dylanclements.bazel").list_targets()
end, { desc = "List all Bazel targets" })

vim.keymap.set("n", "<leader>bt", function()
    local target_name = vim.fn.input("Enter target name: ")
    if target_name ~= "" then
        require("dylanclements.bazel").run_specific_target(target_name)
    end
end, { desc = "Run specific Bazel target" })

vim.keymap.set("n", "<leader>bp", function()
    require("dylanclements.bazel").show_target_picker()
end, { desc = "Interactive Bazel target picker" })



-- Reload Neovim configuration with feedback
vim.keymap.set("n", "<leader>rr", function()
    local success, result = pcall(vim.cmd, "source ~/.config/nvim/init.lua")
    if success then
        vim.notify("✅ Neovim configuration reloaded successfully!", vim.log.levels.INFO, {
            title = "Config Reload",
            timeout = 2000,
        })
    else
        vim.notify("❌ Failed to reload configuration: " .. tostring(result), vim.log.levels.ERROR, {
            title = "Config Reload Error",
            timeout = 5000,
        })
    end
end, { desc = "Reload Neovim config" })

-- Elegant exit with save prompt
vim.keymap.set("n", "<leader>q", function()
    -- Check if there are any unsaved changes
    local has_unsaved = false
    local buffers = vim.api.nvim_list_bufs()
    
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "modifiable") then
            if vim.api.nvim_buf_get_option(buf, "modified") then
                has_unsaved = true
                break
            end
        end
    end
    
    if has_unsaved then
        -- Show a confirmation dialog
        local choice = vim.fn.confirm("You have unsaved changes. Save before quitting?", "&Yes\n&No\n&Cancel", 1)
        
        if choice == 1 then
            -- Save all buffers
            vim.cmd("wall")
            vim.cmd("qa")
        elseif choice == 2 then
            -- Quit without saving
            vim.cmd("qa!")
        end
        -- choice == 3 means cancel, do nothing
    else
        -- No unsaved changes, just quit
        vim.cmd("qa")
    end
end, { desc = "Exit Neovim with save prompt" })


