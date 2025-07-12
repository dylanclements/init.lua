return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers", -- set to "tabs" to get only tabline instead
                separator_style = "slant", -- | "thick" | "thin" | { 'any', 'any' } | "slant" | "padded_slant"
                always_show_bufferline = true,
                show_buffer_close_icons = true,
                show_close_icon = true,
                color_icons = true,
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(_, _, diag)
                    local icons = require("nvim-web-devicons").get_icon("", "", { default = true })
                    local ret = (diag.error and icons .. diag.error .. " " or "")
                        .. (diag.warning and icons .. diag.warning or "")
                    return vim.trim(ret)
                end,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true
                    }
                },
                custom_areas = {
                    right = function()
                        local result = {}
                        local error = vim.diagnostic.get(0, [[severity = vim.diagnostic.severity.ERROR]])
                        local warning = vim.diagnostic.get(0, [[severity = vim.diagnostic.severity.WARN]])
                        local info = vim.diagnostic.get(0, [[severity = vim.diagnostic.severity.INFO]])
                        local hint = vim.diagnostic.get(0, [[severity = vim.diagnostic.severity.HINT]])

                        if #error > 0 then
                            table.insert(result, {text = " " .. #error .. " ", guifg = "#EC5241"})
                        end
                        if #warning > 0 then
                            table.insert(result, {text = " " .. #warning .. " ", guifg = "#EFB839"})
                        end
                        if #info > 0 then
                            table.insert(result, {text = " " .. #info .. " ", guifg = "#A3BA5E"})
                        end
                        if #hint > 0 then
                            table.insert(result, {text = " " .. #hint .. " ", guifg = "#7C3AED"})
                        end
                        return result
                    end,
                },
            },
            highlights = {
                fill = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLineNC" },
                },
                background = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                tab = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                tab_selected = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                tab_close = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                close_button = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                close_button_visible = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                close_button_selected = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                buffer_visible = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                buffer_selected = {
                    fg = { attribute = "fg", highlight = "Normal" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                    bold = true,
                    italic = true,
                },
                separator = {
                    fg = { attribute = "bg", highlight = "StatusLine" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                separator_visible = {
                    fg = { attribute = "bg", highlight = "StatusLine" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                separator_selected = {
                    fg = { attribute = "bg", highlight = "StatusLine" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
                indicator_selected = {
                    fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
                    bg = { attribute = "bg", highlight = "StatusLine" },
                },
            },
        })
    end
} 