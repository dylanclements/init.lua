return {
    "yetone/avante.nvim",
    -- Build from source if needed, otherwise use prebuilt binary
    build = function()
        -- conditionally use the correct build system for the current OS
        if vim.fn.has("win32") == 1 then
            return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        else
            return "make"
        end
    end,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        -- Provider configuration
        provider = "claude",
        providers = {
            claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude-sonnet-4-20250514",
                timeout = 30000, -- Timeout in milliseconds
                extra_request_body = {
                    temperature = 0.75,
                    max_tokens = 20480,
                },
            },
            -- OpenAI alternative (uncomment if needed)
            -- openai = {
            --   endpoint = "https://api.openai.com/v1",
            --   model = "gpt-4o",
            --   timeout = 30000,
            --   extra_request_body = {
            --     temperature = 0.75,
            --     max_tokens = 20480,
            --   },
            -- },
        },
        -- File selector configuration
        selector = {
            exclude_auto_select = { "NvimTree" },
        },
        -- Web search engine configuration
        web_search_engine = {
            provider = "tavily", -- tavily, serpapi, google, kagi, brave, or searxng
            proxy = nil,   -- proxy support, e.g., http://127.0.0.1:7890
        },
        -- RAG service configuration (disabled by default)
        rag_service = {
            enabled = false,          -- Enables the RAG service
            host_mount = os.getenv("HOME"), -- Host mount path for the rag service
            runner = "docker",        -- Runner for the RAG service (can use docker or nix)
            llm = {
                provider = "openai",
                endpoint = "https://api.openai.com/v1",
                api_key = "OPENAI_API_KEY",
                model = "gpt-4o-mini",
                extra = nil,
            },
            embed = {
                provider = "openai",
                endpoint = "https://api.openai.com/v1",
                api_key = "OPENAI_API_KEY",
                model = "text-embedding-3-large",
                extra = nil,
            },
            docker_extra_args = "",
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        -- Optional dependencies for enhanced functionality
        "echasnovski/mini.pick",     -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",          -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",          -- for file_selector provider fzf
        "stevearc/dressing.nvim",    -- for input provider dressing
        "folke/snacks.nvim",         -- for input provider snacks
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",    -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
    keys = {
        -- Sidebar keybindings
        { "<leader>aa", "<cmd>AvanteToggle<cr>",         desc = "avante: show sidebar" },
        { "<leader>at", "<cmd>AvanteToggle<cr>",         desc = "avante: toggle sidebar visibility" },
        { "<leader>ar", "<cmd>AvanteRefresh<cr>",        desc = "avante: refresh sidebar" },
        { "<leader>af", "<cmd>AvanteFocus<cr>",          desc = "avante: switch sidebar focus" },

        -- Suggestion keybindings
        { "<leader>a?", "<cmd>AvanteSwitchProvider<cr>", desc = "avante: select model" },
        { "<leader>an", "<cmd>AvanteAsk<cr>",            desc = "avante: new ask" },
        { "<leader>ae", "<cmd>AvanteEdit<cr>",           desc = "avante: edit selected blocks" },
        { "<leader>aS", "<cmd>AvanteStop<cr>",           desc = "avante: stop current AI request" },
        { "<leader>ah", "<cmd>AvanteHistory<cr>",        desc = "avante: select between chat histories" },
        { "<leader>ad", "<cmd>AvanteToggle<cr>",         desc = "avante: toggle debug mode" },
        { "<leader>as", "<cmd>AvanteToggle<cr>",         desc = "avante: toggle suggestion display" },
        { "<leader>aR", "<cmd>AvanteShowRepoMap<cr>",    desc = "avante: toggle repomap" },

        -- Files keybindings
        { "<leader>ac", "<cmd>AvanteAddFile<cr>",        desc = "avante: add current buffer to selected files" },
        { "<leader>aB", "<cmd>AvanteAddAllBuffers<cr>",  desc = "avante: add all buffer files to selected files" },

        -- NvimTree integration (if you have nvim-tree installed)
        {
            "<leader>a+",
            function()
                local tree_ext = require("avante.extensions.nvim_tree")
                tree_ext.add_file()
            end,
            desc = "avante: select file in NvimTree",
            ft = "NvimTree",
        },
        {
            "<leader>a-",
            function()
                local tree_ext = require("avante.extensions.nvim_tree")
                tree_ext.remove_file()
            end,
            desc = "avante: deselect file in NvimTree",
            ft = "NvimTree",
        },
    },
}

