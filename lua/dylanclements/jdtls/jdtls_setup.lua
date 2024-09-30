local M = {}

function M.setup()
    -- local jdtls = require("jdtls")
    -- local jdtls_dap = require("jdtls.dap")
    local jdtls_setup = require("jdtls.setup")
    local home = os.getenv("HOME")

    local root_markers = { ".git", "WORKSPACE" }
    local root_dir = jdtls_setup.find_root(root_markers)

    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace_dir = home .. "/.cache/jdtls/workspace" .. project_name

    -- 💀
    local path_to_mason_packages = home .. "/.local/share/nvim/mason/packages"
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^

    local path_to_jdtls = path_to_mason_packages .. "/jdtls"

    local path_to_config = path_to_jdtls .. "/config_mac_arm"

    -- 💀
    local path_to_jar = path_to_jdtls ..
        "/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar"

    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^

    local capabilities = {
        workspace = {
            configuration = true
        },
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true
                }
            }
        }
    }

    local config = {
        flags = {
            allow_incremental_sync = true,
        }
    }

    config.cmd = {
        --
        -- 				-- 💀
        "java", -- or '/path/to/java17_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms32g",
        "-Xmx64g",
        -- "-javaagent:" .. lombok_path,
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        -- 💀
        "-jar",
        path_to_jar,
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version

        -- 💀
        "-configuration",
        path_to_config,
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.

        -- 💀
        -- See `data directory configuration` section in the README
        "-data",
        workspace_dir,
    }

    config.settings = {
        java = {},
    }

    config.capabilities = capabilities
    config.on_init = function(client, _)
        client.notify('workspace/didChangeConfiguration', { settings = config.settings })
    end

    local extendedClientCapabilities = require 'jdtls'.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    config.init_options = {
        extendedClientCapabilities = extendedClientCapabilities,
    }

    -- Start Server
    require('jdtls').start_or_attach(config)

    -- TODO: set Java Specific Keymaps
    -- require("jdtls.keymaps")
end

return M
