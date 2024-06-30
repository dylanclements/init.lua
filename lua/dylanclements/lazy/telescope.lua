return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup{
	        defaults = {
		        path_display={"smart"}
	        }
        }

        local builtin = require('telescope.builtin')

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
