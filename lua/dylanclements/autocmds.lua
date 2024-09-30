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
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        -- vim.lsp.set_log_level('DEBUG')

        local home_dir = "/Users/dylanc/"
        local local_share_dir = home_dir .. ".local/share/"
        local workspace_dir = home_dir .. "work/" .. project_name

        -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
        require("jdtls").start_or_attach({
            -- The command that starts the language server
            -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
            cmd = {
                "java", -- or '/path/to/java17_or_newer/bin/java'
                -- depends on if `java` is in your $PATH env variable and if it points to the right version.

                -- "-javaagent:local_share_dir .. java/lombok.jar",
                -- '-Xbootclasspath/a:local_share_dir .. java/lombok.jar',
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                -- '-noverify',
                "-Xms32g",
                "-Xmx64g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",
                "-jar",
                vim.fn.glob(
                    local_share_dir ..
                    "nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher.cocoa.macosx.aarch64_1.2.1100.v20240722-2106.jar")
                -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
                -- Must point to the                                                     Change this to
                -- eclipse.jdt.ls installation                                           the actual version

                    "-configuration",
                local_share_dir .. "nvim/mason/packages/jdtls/config_mac_arm",
                -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                -- Must point to the                      Change to one of `linux`, `win` or `mac`
                -- eclipse.jdt.ls installation            Depending on your system.

                -- See `data directory configuration` section in the README
                "-data",
                workspace_dir,
            },

            -- This is the default if not provided, you can remove it. Or adjust as needed.
            -- One dedicated LSP server & client will be started per unique root_dir
            root_dir = vim.fs.root(0, { ".git", "WORKSPACE" }),

            -- Here you can configure eclipse.jdt.ls specific settings
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            -- for a list of options
            settings = {
                java = {},
            },

            -- add callbacks for events
            handlers = {
                -- ["language/status"] = <function 1>,
                -- ["textDocument/codeAction"] = <function 2>,
                -- ["textDocument/rename"] = <function 3>,
                -- ["workspace/applyEdit"] = <function 4>
            },
        })
    end,
})
