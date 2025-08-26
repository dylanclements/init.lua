return {
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        config = function()
            require("clangd_extensions").setup({
                inlay_hints = {
                    inline = false,
                    only_current_line = false,
                    only_current_line_autocmd = "CursorHold",
                    show_parameter_hints = true,
                    parameter_hints_prefix = "<- ",
                    other_hints_prefix = "=> ",
                    max_len_align = false,
                    max_len_align_padding = 1,
                    right_align = false,
                    right_align_padding = 7,
                    highlight = "Comment",
                },
                ast = {
                    role_icons = {
                        type = "",
                        declaration = "",
                        expression = "",
                        specifier = "",
                        statement = "",
                        ["template argument"] = "",
                    },
                    kind_icons = {
                        Compound = "",
                        Recovery = "",
                        TranslationUnit = "",
                        PackExpansion = "",
                        TemplateTypeParm = "",
                        TemplateTemplateParm = "",
                        TemplateParamObject = "",
                    },
                },
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>F",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "",
                desc = "Format buffer with conform",
            },
        },
        opts = {
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
}
