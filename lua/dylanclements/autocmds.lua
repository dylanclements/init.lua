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