local ensure_installed = {
    -- lua
    "lua_ls",

    -- python
    "pyright",

    -- bash
    "bashls",

    -- yaml
    "yamlls",

    -- terraform
    "terraformls",

    -- docker
    "dockerls",

    -- go
    "gopls",

    -- elixir
    "elixirls",

    -- webdev
    "ts_ls",
    "eslint",
    "html",
    "tailwindcss",
    "cssls",
    "jsonls",

    -- markdown
    "marksman",

    -- rust
    "rust_analyzer",

    -- c/c++
    "clangd",
}


return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim",           version = "v1.10.0" },
        { "williamboman/mason-lspconfig.nvim", version = "v1.29.0" },
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",

    },
    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
            -- automatic_enable = false,
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = {
                                        "vim",
                                        "it",
                                        "describe",
                                        "before_each",
                                        "after_each"
                                    },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        -- LSP keymaps
        -- Format buffer with LSP
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer with LSP" })

        -- Toggle LSP for current buffer
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

        -- LSP keymaps that are set up when LSP attaches to a buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
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
    end
}
