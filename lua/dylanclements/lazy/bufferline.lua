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

        -- Bufferline keymaps
        -- Tab navigation
        vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to tab 1" })
        vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to tab 2" })
        vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to tab 3" })
        vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to tab 4" })
        vim.keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to tab 5" })
        vim.keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", { desc = "Go to tab 6" })
        vim.keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", { desc = "Go to tab 7" })
        vim.keymap.set("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", { desc = "Go to tab 8" })
        vim.keymap.set("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", { desc = "Go to tab 9" })

        -- Tab navigation
        vim.keymap.set("n", "<leader>gt", "<cmd>BufferLineCycleNext<CR>", { desc = "Next tab" })
        vim.keymap.set("n", "<leader>gT", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous tab" })

        -- Tab management
        vim.keymap.set("n", "<leader>tc", "<cmd>BufferLineClose<CR>", { desc = "Close current tab" })
        vim.keymap.set("n", "<leader>to", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other tabs" })
        vim.keymap.set("n", "<leader>tr", "<cmd>BufferLineCloseRight<CR>", { desc = "Close tabs to the right" })
        vim.keymap.set("n", "<leader>tl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close tabs to the left" })
        vim.keymap.set("n", "<leader>tn", "<cmd>enew<CR>", { desc = "New tab" })
        vim.keymap.set("n", "<leader>tp", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin/unpin tab" })
        vim.keymap.set("n", "<leader>tm", "<cmd>BufferLineMoveNext<CR>", { desc = "Move tab right" })
        vim.keymap.set("n", "<leader>tM", "<cmd>BufferLineMovePrev<CR>", { desc = "Move tab left" })
        vim.keymap.set("n", "<leader>ts", "<cmd>BufferLineSortByExtension<CR>", { desc = "Sort tabs by extension" })
    end
} 