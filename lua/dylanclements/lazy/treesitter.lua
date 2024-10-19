local ensure_installed = {
    -- web dev
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "json",

    -- misc
    "yaml",

    -- docker
    "dockerfile",
    "regex",

    -- lua
    "lua",

    -- bash
    "bash",

    -- jvm
    "java",
    "kotlin",

    -- bazel
    "starlark",

    -- nix
    "nix",

    -- terraform
    "terraform",

    -- python
    "python",

    -- elixir
    "elixir",
    "erlang",
    "heex",
}

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = ensure_installed,
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = false,

            indent = {
                enable = true
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { "markdown" },
            },
        })
    end
}
