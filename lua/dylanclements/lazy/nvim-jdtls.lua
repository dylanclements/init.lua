return {
    "mfussenegger/nvim-jdtls",
    config = function()
        local function get_root_dir()
            -- Search for Bazel build files or other project indicators
            local project_root = vim.fs.find({'WORKSPACE', 'BUILD', '.git'}, { upward = true })

            if project_root and #project_root > 0 then
                return vim.fs.dirname(project_root[1])
            else
                -- Fallback to the current working directory if no marker file is found
                return vim.fn.getcwd()
            end
        end

        local config = {
            cmd = {'/opt/homebrew/bin/jdtls'},
            root_dir = get_root_dir(),
            workspaceFolders = {
                {
                    name = 'workspace',
                    path = vim.fn.expand('~/.jdtls-workspace')
                }
            },
            settings = {
                java = {
                    project = {
                        referencedLibraries = {
                            get_root_dir() .. '/bazel-bin/**/*.jar',
                        },
                    },
                },
            },
        }

        -- require('jdtls').start_or_attach(config)
    end
}

