-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- fuzzy finder
    use {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- fugitive
    use 'tpope/vim-fugitive'

    -- dracula theme
    use({
        'Mofiqul/dracula.nvim',
        as = 'dracula',
        config = function()
            vim.cmd('colorscheme dracula')
        end
    })

    -- syntax highlighting
    use('nvim-treesitter/nvim-treesitter', { run = ":TSUpdate" })

    -- harpoon, easily switch between buffers
    use('theprimeagen/harpoon')

    -- undotree (non-linear undo)
    use('mbbill/undotree')

    -- lsp stuff
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'

    -- cosmetic animations, just for fun
    use 'eandrju/cellular-automaton.nvim'

    -- use 'github/copilot.vim'

    -- java developer tools
    use 'mfussenegger/nvim-jdtls'

    -- nvim tree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }
end)
