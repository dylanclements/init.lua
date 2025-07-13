local M = {}

-- Function to check if we're in a Bazel workspace
local function is_bazel_workspace()
    local current_dir = vim.fn.getcwd()
    local workspace_file = vim.fn.findfile("WORKSPACE", current_dir .. ";")
    return workspace_file ~= ""
end

-- Function to find BUILD files in the current directory and parent directories
local function find_build_files()
    local current_dir = vim.fn.getcwd()
    local build_files = {}
    
    -- Search for BUILD files in current directory and parents
    local search_path = current_dir
    local max_depth = 10 -- Prevent infinite loops
    
    for i = 1, max_depth do
        local build_file = vim.fn.findfile("BUILD", search_path .. ";")
        if build_file ~= "" then
            table.insert(build_files, build_file)
        end
        
        -- Move up one directory
        local parent = vim.fn.fnamemodify(search_path, ":h")
        if parent == search_path then
            break -- Reached root directory
        end
        search_path = parent
    end
    
    return build_files
end

-- Function to extract target names from BUILD files
local function extract_targets_from_build_file(build_file_path)
    local targets = {}
    local file = io.open(build_file_path, "r")
    if not file then
        return targets
    end
    
    local content = file:read("*all")
    file:close()
    
    -- Look for common Bazel target patterns
    for target_type in content:gmatch("([a-z_]+)%s*%(") do
        if target_type == "cc_binary" or target_type == "cc_library" or 
           target_type == "cc_test" or target_type == "java_binary" or 
           target_type == "java_library" or target_type == "java_test" or
           target_type == "py_binary" or target_type == "py_library" or
           target_type == "py_test" or target_type == "go_binary" or
           target_type == "go_library" or target_type == "go_test" then
            
            -- Extract the target name
            for target_name in content:gmatch('name%s*=%s*["\']([^"\']+)["\']') do
                table.insert(targets, {
                    name = target_name,
                    type = target_type,
                    build_file = build_file_path
                })
            end
        end
    end
    
    return targets
end

-- Function to get all available targets
local function get_available_targets()
    if not is_bazel_workspace() then
        return {}
    end
    
    local build_files = find_build_files()
    local all_targets = {}
    
    for _, build_file in ipairs(build_files) do
        local targets = extract_targets_from_build_file(build_file)
        for _, target in ipairs(targets) do
            table.insert(all_targets, target)
        end
    end
    
    return all_targets
end

-- Function to find the most relevant target for the current file
local function find_relevant_target()
    local current_file = vim.fn.expand("%:p")
    local current_dir = vim.fn.expand("%:p:h")
    local targets = get_available_targets()
    
    if #targets == 0 then
        return nil
    end
    
    -- First, try to find a target in the same directory as the current file
    for _, target in ipairs(targets) do
        local build_file_dir = vim.fn.fnamemodify(target.build_file, ":h")
        if build_file_dir == current_dir then
            return target
        end
    end
    
    -- If no target in current directory, return the first available target
    return targets[1]
end

-- Function to build the target path for Bazel
local function get_target_path(target)
    if not target then
        return nil
    end
    
    local build_file_dir = vim.fn.fnamemodify(target.build_file, ":h")
    local workspace_root = vim.fn.findfile("WORKSPACE", build_file_dir .. ";")
    local workspace_dir = vim.fn.fnamemodify(workspace_root, ":h")
    
    -- Calculate relative path from workspace root to build file directory
    local current_dir = vim.fn.getcwd()
    vim.fn.chdir(workspace_dir)
    local relative_path = vim.fn.fnamemodify(build_file_dir, ":.")
    vim.fn.chdir(current_dir)
    
    -- Construct the target path
    local target_path
    if relative_path == "." then
        target_path = "//:" .. target.name
    else
        target_path = "//" .. relative_path .. ":" .. target.name
    end
    
    return target_path
end

-- Function to run Bazel build in a vertical split terminal
function M.run_bazel_build()
    if not is_bazel_workspace() then
        vim.notify("❌ No Bazel workspace found in current directory", vim.log.levels.WARN, {
            title = "Bazel Build",
            timeout = 3000,
        })
        return
    end
    
    local targets = get_available_targets()
    if #targets == 0 then
        vim.notify("❌ No Bazel build targets found in current workspace", vim.log.levels.WARN, {
            title = "Bazel Build",
            timeout = 3000,
        })
        return
    end
    
    -- If there's only one target, build it directly
    if #targets == 1 then
        local target = targets[1]
        local target_path = get_target_path(target)
        if not target_path then
            vim.notify("❌ Could not determine target path", vim.log.levels.ERROR, {
                title = "Bazel Build",
                timeout = 3000,
            })
            return
        end
        
        -- Create vertical split and open terminal
        vim.cmd("vsplit")
        vim.cmd("terminal")
        
        -- Move to the terminal window and wait for it to be ready
        vim.cmd("wincmd l")
        
        -- Wait a moment for the terminal to be ready
        vim.defer_fn(function()
            -- Send the bazel build command
            local build_command = string.format("bazel build %s", target_path)
            vim.api.nvim_chan_send(vim.b.terminal_job_id, build_command .. "\n")
            
            -- Notify user
            vim.notify(string.format("🚀 Building target: %s", target_path), vim.log.levels.INFO, {
                title = "Bazel Build",
                timeout = 2000,
            })
        end, 100)
    else
        -- Multiple targets available, show picker
        vim.notify(string.format("📋 Found %d targets. Opening picker...", #targets), vim.log.levels.INFO, {
            title = "Bazel Build",
            timeout = 2000,
        })
        M.show_target_picker()
    end
end

-- Function to list all available targets
function M.list_targets()
    if not is_bazel_workspace() then
        vim.notify("❌ No Bazel workspace found in current directory", vim.log.levels.WARN, {
            title = "Bazel Targets",
            timeout = 3000,
        })
        return
    end
    
    local targets = get_available_targets()
    if #targets == 0 then
        vim.notify("❌ No Bazel build targets found in current workspace", vim.log.levels.WARN, {
            title = "Bazel Targets",
            timeout = 3000,
        })
        return
    end
    
    -- Create a quickfix list with all targets
    local qf_list = {}
    for _, target in ipairs(targets) do
        local target_path = get_target_path(target)
        table.insert(qf_list, {
            filename = target.build_file,
            lnum = 1,
            col = 1,
            text = string.format("%s (%s) - %s", target_path, target.type, target.name)
        })
    end
    
    vim.fn.setqflist(qf_list)
    vim.cmd("copen")
    
    vim.notify(string.format("📋 Found %d Bazel targets", #targets), vim.log.levels.INFO, {
        title = "Bazel Targets",
        timeout = 2000,
    })
end

-- Function to run a specific target by name
function M.run_specific_target(target_name)
    if not is_bazel_workspace() then
        vim.notify("❌ No Bazel workspace found in current directory", vim.log.levels.WARN, {
            title = "Bazel Build",
            timeout = 3000,
        })
        return
    end
    
    local targets = get_available_targets()
    local selected_target = nil
    
    for _, target in ipairs(targets) do
        if target.name == target_name then
            selected_target = target
            break
        end
    end
    
    if not selected_target then
        vim.notify(string.format("❌ Target '%s' not found", target_name), vim.log.levels.ERROR, {
            title = "Bazel Build",
            timeout = 3000,
        })
        return
    end
    
    local target_path = get_target_path(selected_target)
    
    -- Create vertical split and open terminal
    vim.cmd("vsplit")
    vim.cmd("terminal")
    
    -- Move to the terminal window and wait for it to be ready
    vim.cmd("wincmd l")
    
    -- Wait a moment for the terminal to be ready
    vim.defer_fn(function()
        -- Send the bazel build command
        local build_command = string.format("bazel build %s", target_path)
        vim.api.nvim_chan_send(vim.b.terminal_job_id, build_command .. "\n")
        
        -- Notify user
        vim.notify(string.format("🚀 Building target: %s", target_path), vim.log.levels.INFO, {
            title = "Bazel Build",
            timeout = 2000,
        })
    end, 100)
end

-- Function to run a Bazel command (build, test, run) on a target
local function run_bazel_command(target, command_type)
    local target_path = get_target_path(target)
    if not target_path then
        vim.notify("❌ Could not determine target path", vim.log.levels.ERROR, {
            title = "Bazel " .. command_type:upper(),
            timeout = 3000,
        })
        return
    end
    
    -- Create vertical split and open terminal
    vim.cmd("vsplit")
    vim.cmd("terminal")
    
    -- Move to the terminal window and wait for it to be ready
    vim.cmd("wincmd l")
    
    -- Wait a moment for the terminal to be ready
    vim.defer_fn(function()
        -- Send the bazel command
        local bazel_command = string.format("bazel %s %s", command_type, target_path)
        vim.api.nvim_chan_send(vim.b.terminal_job_id, bazel_command .. "\n")
        
        -- Notify user
        vim.notify(string.format("🚀 %s target: %s", command_type:upper(), target_path), vim.log.levels.INFO, {
            title = "Bazel " .. command_type:upper(),
            timeout = 2000,
        })
    end, 100)
end

-- Function to show interactive target picker
function M.show_target_picker()
    if not is_bazel_workspace() then
        vim.notify("❌ No Bazel workspace found in current directory", vim.log.levels.WARN, {
            title = "Bazel Targets",
            timeout = 3000,
        })
        return
    end
    
    local targets = get_available_targets()
    if #targets == 0 then
        vim.notify("❌ No Bazel build targets found in current workspace", vim.log.levels.WARN, {
            title = "Bazel Targets",
            timeout = 3000,
        })
        return
    end
    
    -- Create picker items
    local picker_items = {}
    for _, target in ipairs(targets) do
        local target_path = get_target_path(target)
        table.insert(picker_items, {
            name = target.name,
            type = target.type,
            path = target_path,
            build_file = target.build_file,
            display = string.format("%s (%s) - %s", target_path, target.type, target.name)
        })
    end
    
    -- Check if telescope is available for a nice picker interface
    local has_telescope = pcall(require, "telescope")
    if has_telescope then
        -- Use telescope picker
        local telescope = require("telescope")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        
        local function target_action(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            
            -- Show command selection
            local commands = {"build", "test", "run"}
            local command_items = {}
            for _, cmd in ipairs(commands) do
                table.insert(command_items, {
                    name = cmd,
                    display = string.format("bazel %s %s", cmd, selection.value.path)
                })
            end
            
            local command_picker = pickers.new({}, {
                prompt_title = "Select Bazel Command",
                finder = finders.new_table({
                    results = command_items,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = entry.display,
                            ordinal = entry.name,
                        }
                    end
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        local cmd_selection = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        run_bazel_command(selection.value, cmd_selection.value.name)
                    end)
                    return true
                end,
            })
            command_picker:find()
        end
        
        local picker = pickers.new({}, {
            prompt_title = "Select Bazel Target",
            finder = finders.new_table({
                results = picker_items,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry.display,
                        ordinal = entry.name,
                    }
                end
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(target_action)
                return true
            end,
        })
        picker:find()
    else
        -- Fallback to vim.ui.select if available (Neovim 0.8+)
        if vim.ui.select then
            local items = {}
            for _, item in ipairs(picker_items) do
                table.insert(items, item.display)
            end
            
            vim.ui.select(items, {
                prompt = "Select Bazel Target:",
            }, function(choice, idx)
                if choice and idx then
                    local selected_target = picker_items[idx]
                    -- Show command selection
                    local commands = {"build", "test", "run"}
                    vim.ui.select(commands, {
                        prompt = "Select Bazel Command:",
                    }, function(cmd_choice)
                        if cmd_choice then
                            run_bazel_command(selected_target, cmd_choice)
                        end
                    end)
                end
            end)
        else
            -- Fallback to quickfix list
            local qf_list = {}
            for _, target in ipairs(targets) do
                local target_path = get_target_path(target)
                table.insert(qf_list, {
                    filename = target.build_file,
                    lnum = 1,
                    col = 1,
                    text = string.format("%s (%s) - %s", target_path, target.type, target.name)
                })
            end
            
            vim.fn.setqflist(qf_list)
            vim.cmd("copen")
            
            vim.notify("📋 Use quickfix list to select targets. Press <leader>bt to run specific target.", vim.log.levels.INFO, {
                title = "Bazel Targets",
                timeout = 3000,
            })
        end
    end
end

return M 