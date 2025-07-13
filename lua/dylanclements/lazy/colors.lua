function ColorMyPencils(color)
	color = color or "jb"
	vim.cmd.colorscheme(color)
end


return {
    {
        "erikbackman/brightburn.vim"
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark", -- style for floating windows
                },
            })
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })
        end
    },
    {
        "nickkadutskyi/jb.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            -- Configure jb.nvim with custom background
            require("jb").setup({
                transparent = false, -- Disable transparency to get solid background
                disable_hl_args = {
                    bold = false,
                    italic = false,
                },
                snacks = {
                    explorer = {
                        enabled = true,
                    },
                },
            })
            
            -- Apply the colorscheme
            ColorMyPencils("jb")
            
            -- Override specific highlight groups for IntelliJ-like grey background
            local grey_bg = "#2b2b2b"  -- IntelliJ-like grey
            local float_bg = "#3c3f41" -- Slightly lighter grey for floating windows
            
            -- Set background for main areas
            vim.api.nvim_set_hl(0, "Normal", { bg = grey_bg })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = float_bg })
            
            -- Set background for inactive buffers and windows
            vim.api.nvim_set_hl(0, "NonText", { bg = grey_bg })
            vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = grey_bg })
            vim.api.nvim_set_hl(0, "SignColumn", { bg = grey_bg })
            vim.api.nvim_set_hl(0, "LineNr", { bg = grey_bg })
            vim.api.nvim_set_hl(0, "CursorLine", { bg = "#323232" }) -- Slightly lighter for cursor line
            vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#323232" })
            
            -- Set background for status line and tab line
            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#3c3f41" })
            vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#2b2b2b" })
            vim.api.nvim_set_hl(0, "TabLine", { bg = "#3c3f41" })
            vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#2b2b2b" })
            
            -- Set background for sidebar and tree
            vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = grey_bg })
            vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = grey_bg })
            vim.api.nvim_set_hl(0, "NvimTreeStatusLine", { bg = grey_bg })
        end,
    },
}
