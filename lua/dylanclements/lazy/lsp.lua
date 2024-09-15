return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "mfussenegger/nvim-jdtls",
    },
    opts = {
        setup = {
            jdtls = function(_, opts)
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = "java",
                    callback = function()
                        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
                        -- vim.lsp.set_log_level('DEBUG')
                        local workspace_dir = "/User/dylanc/work/" ..
                            project_name -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
                        local config = {
                            -- The command that starts the language server
                            -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
                            cmd = {

                                "java", -- or '/path/to/java17_or_newer/bin/java'
                                -- depends on if `java` is in your $PATH env variable and if it points to the right version.

                                "-javaagent:/home/jake/.local/share/java/lombok.jar",
                                -- '-Xbootclasspath/a:/home/jake/.local/share/java/lombok.jar',
                                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                                "-Dosgi.bundles.defaultStartLevel=4",
                                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                                "-Dlog.protocol=true",
                                "-Dlog.level=ALL",
                                -- '-noverify',
                                "-Xms64g",
                                "--add-modules=ALL-SYSTEM",
                                "--add-opens",
                                "java.base/java.util=ALL-UNNAMED",
                                "--add-opens",
                                "java.base/java.lang=ALL-UNNAMED",
                                "-jar",
                                vim.fn.glob(
                                    "/Users/dylanc/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher.cocoa.macosx.aarch64_1.2.1100.v20240722-2106.jar")
                                -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
                                -- Must point to the                                                     Change this to
                                -- eclipse.jdt.ls installation                                           the actual version

                                    "-configuration",
                                "/Users/dylanc/.local/share/nvim/mason/packages/jdtls/config_mac_arm",
                                -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                                -- Must point to the                      Change to one of `linux`, `win` or `mac`
                                -- eclipse.jdt.ls installation            Depending on your system.

                                -- See `data directory configuration` section in the README
                                "-data",
                                workspace_dir,
                            },

                            -- This is the default if not provided, you can remove it. Or adjust as needed.
                            -- One dedicated LSP server & client will be started per unique root_dir
                            root_dir = require("jdtls.setup").find_root({ ".git", "WORKSPACE" }),

                            -- Here you can configure eclipse.jdt.ls specific settings
                            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                            -- for a list of options
                            settings = {
                                java = {},
                            },
                            handlers = {
                                ["language/status"] = function(_, result)
                                    -- print(result)
                                end,
                                ["$/progress"] = function(_, result, ctx)
                                    -- disable progress updates.
                                end,
                            },
                        }
                        require("jdtls").start_or_attach(config)
                    end,
                })
                return true
            end,
        },
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
            ensure_installed = {
                "lua_ls",
                "pyright",
                "bashls",
                "terraformls",
                "yamlls",
                "sqlls",
                "dockerls",
                "nil_ls",
                'jdtls',
                "gopls",
            },
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
    end
}
