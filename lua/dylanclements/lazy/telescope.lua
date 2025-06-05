return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        -- Store current path display mode
        local current_path_display = { "truncate" }

        require('telescope').setup{
	        defaults = {
		        path_display = current_path_display
	        }
        }

        local builtin = require('telescope.builtin')

        -- Toggle path display mode
        vim.keymap.set('n', '<leader>tp', function()
            local telescope_config = require('telescope.config')

            if current_path_display[1] == "truncate" then
                current_path_display[1] = "smart"
                print("Telescope: Smart path display")
            elseif current_path_display[1] == "smart" then
                current_path_display[1] = "tail"
                print("Telescope: Filename only")
            else
                current_path_display[1] = "truncate"
                print("Telescope: Full paths from repo root")
            end

            -- Update the telescope configuration
            telescope_config.values.path_display = current_path_display
        end, { desc = "Toggle Telescope path display mode" })

        -- find files
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

        -- find in git files
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})

        -- search open buffers
        vim.keymap.set('n', '<leader>pb', builtin.buffers, {})

        -- search for word
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)

        -- search for WORD
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)

        -- enter custom string in there
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}
