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


-- prettier format on save
autocmd({ "BufWritePre" }, {
    group = DylanClementsGroup,
    pattern = { "*.js", "*.ts", "*.cjs", "*.mjs" },
    command = "Neoformat"
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
    },
    group = CustomIndentation,
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})


-- Spin up JDTLS if we are in a java file
autocmd("FileType", {
    group = DylanClementsGroup,
    pattern = "java",
    callback = function()
        require('jdtls.jdtls_setup').setup()
    end,
})
