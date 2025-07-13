#!/bin/bash

# Bazel Test Runner Script
# This script runs the comprehensive Bazel test suite

echo "🧪 Starting Bazel Test Suite..."
echo "=================================="

# Check if we're in the right directory
if [ ! -f "lua/dylanclements/bazel.lua" ]; then
    echo "❌ Error: bazel.lua not found. Please run this script from the nvim config root directory."
    exit 1
fi

# Check if Neovim is available
if ! command -v nvim &> /dev/null; then
    echo "❌ Error: Neovim not found. Please install Neovim to run tests."
    exit 1
fi

# Create a temporary test configuration
cat > /tmp/bazel_test_init.lua << 'EOF'
-- Minimal Neovim config for testing
vim.opt.runtimepath:prepend(".")

-- Set test mode flag
vim.g.bazel_test_mode = true

-- Load the bazel module
require("dylanclements.bazel")

-- Mock terminal functionality for testing
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.b.terminal_job_id = 12345  -- Mock job ID
    end
})

-- Mock vim.api.nvim_chan_send for testing
local original_chan_send = vim.api.nvim_chan_send
vim.api.nvim_chan_send = function(chan_id, data)
    -- Just log the command instead of actually sending it
    print("Mock terminal command: " .. data:gsub("\n", ""))
end

-- Mock vim.defer_fn for testing
if not vim.defer_fn then
    vim.defer_fn = function(fn, delay)
        fn()
    end
end

-- Mock vim.ui.select for testing
vim.ui.select = function(items, opts, callback)
    if callback then
        -- Always select the first item automatically
        callback(items[1], 1)
    end
end

-- Mock vim.fn.input for testing
vim.fn.input = function(prompt)
    -- Return a default value for any input prompts
    return "test_input"
end

-- Mock telescope require
local telescope_mock = {
    pickers = {
        new = function(opts)
            return {
                find = function()
                    -- Automatically trigger the default action immediately
                    if opts.attach_mappings then
                        local mock_bufnr = 1
                        opts.attach_mappings(mock_bufnr, {})
                    end
                end
            }
        end
    },
    finders = {
        new_table = function(opts)
            return opts
        end
    },
    config = {
        values = {
            generic_sorter = function()
                return function() end
            end
        }
    },
    actions = {
        close = function() end,
        select_default = {
            replace = function(fn)
                -- Execute the function immediately
                fn()
            end
        }
    },
    actions_state = {
        get_selected_entry = function()
            return {
                value = {
                    name = "test_target",
                    path = "//test:test_target"
                }
            }
        end
    }
}

local original_require = require
require = function(module)
    if module == "telescope" then
        return telescope_mock
    elseif module == "telescope.pickers" then
        return telescope_mock.pickers
    elseif module == "telescope.finders" then
        return telescope_mock.finders
    elseif module == "telescope.config" then
        return telescope_mock.config
    elseif module == "telescope.actions" then
        return telescope_mock.actions
    elseif module == "telescope.actions.state" then
        return telescope_mock.actions_state
    else
        return original_require(module)
    end
end
EOF

echo "📋 Running Bazel functionality tests..."

# Run the test suite with explicit exit
nvim --headless --noplugin -u /tmp/bazel_test_init.lua -c "lua require('test.bazel.bazel_tests')" -c "quit!" 2>&1

# Clean up
rm -f /tmp/bazel_test_init.lua

echo ""
echo "✅ Test suite completed!"
echo "Check the output above for test results." 