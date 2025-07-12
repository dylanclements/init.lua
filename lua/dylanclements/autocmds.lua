local augroup = vim.api.nvim_create_augroup
local DylanClementsGroup = augroup('DylanClements', {})

local autocmd = vim.api.nvim_create_autocmd
local YankGroup = augroup('HighlightYank', {})

-- Gives highlight to yanked text
autocmd('TextYankPost', {
    group = YankGroup,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})


-- Removes trailing whitespace from the buffer after saving
autocmd({ "BufWritePre" }, {
    group = DylanClementsGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- LSP format on save
autocmd("BufWritePre", {
    group = DylanClementsGroup,
    pattern = "*",
    callback = function()
        -- Check if any LSP client supports formatting for this buffer
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
            if client.server_capabilities.documentFormattingProvider then
                vim.lsp.buf.format({
                    async = false,
                    timeout_ms = 2000,
                })
                return
            end
        end
    end,
})





-- When the LSP (Language Server Protocol) attaches to the buffer
-- this autocommand is triggered to set up useful keymaps
autocmd('LspAttach', {
    group = DylanClementsGroup,
    callback = function(e)
        -- Define options to apply the keymaps to the current buffer only
        local opts = { buffer = e.buf }

        -- Go to the definition of the symbol under the cursor
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

        -- Show documentation for the symbol under the cursor in a floating window
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

        -- Search for symbols in the entire workspace (e.g., functions, classes)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)

        -- Open a floating window displaying diagnostics (e.g., errors, warnings) for the current line
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)

        -- Show available code actions for the current line (e.g., quick fixes or refactoring)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

        -- List all references to the symbol under the cursor
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)

        -- Rename the symbol under the cursor
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)

        -- Show signature help for the function signature in insert mode (useful for parameters)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        -- Jump to the next diagnostic message (error, warning, etc.) in the buffer
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)

        -- Jump to the previous diagnostic message in the buffer
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

local CustomIndentation = augroup('CustomIndentation', {})

-- by default set file indents to 4 spaces
autocmd("FileType", {
    pattern = "*",
    group = CustomIndentation,
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
    end,
})

-- set these languages to 2 spaces
autocmd("FileType", {
    pattern = {
        "java",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "yaml",
        "css",
        "elixir",
        "eelixir",
        "prisma",
        "json",
        "jsonc",
    },
    group = CustomIndentation,
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Handle JSON files with comments (JSONC)
local JsonGroup = augroup('JsonWithComments', {})

-- Detect common JSONC files and set filetype to jsonc
autocmd({ "BufRead", "BufNewFile" }, {
    group = JsonGroup,
    pattern = {
        "tsconfig*.json",
        ".vscode/*.json",
        ".eslintrc.json",
        ".prettierrc.json",
        "*.jsonc",
    },
    callback = function()
        vim.bo.filetype = "jsonc"
        vim.bo.commentstring = "// %s"
    end,
})

-- Auto-enable JSONC for all JSON files in 'dynamic-config' repository
autocmd({ "BufRead", "BufNewFile" }, {
    group = JsonGroup,
    pattern = "*.json",
    callback = function()
        -- Get the current working directory and check if we're in dynamic-config repo
        local cwd = vim.fn.getcwd()
        local repo_name = vim.fn.fnamemodify(cwd, ":t")

        -- If we're in dynamic-config repo, treat all JSON files as JSONC
        if repo_name == "dynamic-config" then
            vim.bo.filetype = "jsonc"
            vim.bo.commentstring = "// %s"
        end
    end,
})

-- For regular JSON files, you can toggle comment support with a keymap
-- Add this keymap to toggle between strict JSON and JSON with comments
vim.keymap.set("n", "<leader>jc", function()
    if vim.bo.filetype == "json" then
        vim.bo.filetype = "jsonc"
        vim.bo.commentstring = "// %s"
        print("Switched to JSONC (comments allowed)")
    elseif vim.bo.filetype == "jsonc" then
        vim.bo.filetype = "json"
        vim.bo.commentstring = ""
        print("Switched to strict JSON")
    end
end, { desc = "Toggle JSON/JSONC mode" })
