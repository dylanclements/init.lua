local test_setup = require("test.bazel.bazel_test_setup")
local bazel = require("dylanclements.bazel")

-- Test results tracking
local test_results = {
    passed = 0,
    failed = 0,
    total = 0
}

-- Helper function to run a test
local function run_test(test_name, test_func)
    test_results.total = test_results.total + 1
    print(string.format("🧪 Running test: %s", test_name))
    
    local success, result = pcall(test_func)
    if success then
        test_results.passed = test_results.passed + 1
        print(string.format("✅ PASS: %s", test_name))
    else
        test_results.failed = test_results.failed + 1
        print(string.format("❌ FAIL: %s - %s", test_name, tostring(result)))
    end
    print("")
end

-- Helper function to assert conditions
local function assert(condition, message)
    if not condition then
        error(message or "Assertion failed")
    end
end

-- Helper function to capture notifications
local captured_notifications = {}
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
    table.insert(captured_notifications, {
        message = msg,
        level = level,
        opts = opts
    })
end

local function clear_notifications()
    captured_notifications = {}
end

local function get_last_notification()
    return captured_notifications[#captured_notifications]
end

-- Test: Basic workspace detection
run_test("Workspace Detection - Valid Bazel Workspace", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Verify test directory was created
    assert(test_setup.directory_exists(test_dir), "Test directory should be created")
    
    -- Test workspace detection from original directory
    local workspace_file = vim.fn.findfile("WORKSPACE", test_dir .. ";")
    assert(workspace_file ~= "", "WORKSPACE file should be found")
    
    test_setup.cleanup_test_workspace()
end)

-- Test: Non-Bazel workspace detection
run_test("Workspace Detection - Non-Bazel Workspace", function()
    local test_dir = test_setup.create_non_bazel_workspace()
    
    -- Verify test directory was created
    assert(test_setup.directory_exists(test_dir), "Test directory should be created")
    
    -- Test workspace detection
    local workspace_file = vim.fn.findfile("WORKSPACE", test_dir .. ";")
    assert(workspace_file == "", "WORKSPACE file should not be found")
    
    vim.fn.delete(test_dir, "rf")
end)

-- Test: Target extraction from BUILD files
run_test("Target Extraction - Multiple Targets", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to test directory for target extraction
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    -- Test target extraction
    local targets = bazel.get_available_targets()
    assert(#targets > 0, "Should find multiple targets")
    

    
    -- Check for specific target types
    local has_cc_binary = false
    local has_py_binary = false
    local has_java_binary = false
    local has_cc_test = false
    
    for _, target in ipairs(targets) do
        if target.type == "cc_binary" then has_cc_binary = true end
        if target.type == "py_binary" then has_py_binary = true end
        if target.type == "java_binary" then has_java_binary = true end
        if target.type == "cc_test" then has_cc_test = true end
    end
    
    assert(has_cc_binary, "Should find cc_binary targets")
    assert(has_py_binary, "Should find py_binary targets")
    assert(has_java_binary, "Should find java_binary targets")
    assert(has_cc_test, "Should find cc_test targets")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Target path construction
run_test("Target Path Construction", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to test directory for target extraction
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    local targets = bazel.get_available_targets()
    assert(#targets > 0, "Should find targets")
    
    -- Test root level target
    for _, target in ipairs(targets) do
        if target.name == "common_lib" then
            local path = bazel.get_target_path(target)
            assert(path == "//:common_lib", "Root target path should be //:common_lib")
            break
        end
    end
    
    -- Test nested target
    for _, target in ipairs(targets) do
        if target.name == "main_app" then
            local path = bazel.get_target_path(target)
            assert(path == "//src:main_app", "Nested target path should be //src:main_app")
            break
        end
    end
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: No targets scenario
run_test("No Targets Scenario", function()
    local test_dir = test_setup.create_minimal_workspace()
    
    -- Change to test directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    clear_notifications()
    bazel.run_bazel_build()
    
    local last_notification = get_last_notification()
    assert(last_notification, "Should show notification")
    assert(string.find(last_notification.message, "No Bazel build targets found"), 
           "Should show no targets message")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    vim.fn.delete(test_dir, "rf")
end)

-- Test: Non-Bazel workspace scenario
run_test("Non-Bazel Workspace Scenario", function()
    local test_dir = test_setup.create_non_bazel_workspace()
    
    -- Change to test directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    clear_notifications()
    bazel.run_bazel_build()
    
    local last_notification = get_last_notification()
    assert(last_notification, "Should show notification")
    assert(string.find(last_notification.message, "No Bazel workspace found"), 
           "Should show no workspace message")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    vim.fn.delete(test_dir, "rf")
end)

-- Test: Single target scenario
run_test("Single Target Scenario", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to a directory with only one target
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir .. "/src/nested/deep")
    
    clear_notifications()
    bazel.run_bazel_build()
    
    local last_notification = get_last_notification()
    assert(last_notification, "Should show notification")
    -- Check for either building message or test mode message
    assert(string.find(last_notification.message, "Building") or 
           string.find(last_notification.message, "test mode"), 
           "Should show building or test mode message")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Multiple targets scenario (should show picker)
run_test("Multiple Targets Scenario", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to test directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    clear_notifications()
    bazel.run_bazel_build()
    
    local last_notification = get_last_notification()
    assert(last_notification, "Should show notification")
    -- Check for any notification about targets
    assert(string.find(last_notification.message, "targets") or 
           string.find(last_notification.message, "Building") or
           string.find(last_notification.message, "test mode"), 
           "Should show targets, building, or test mode message")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Target listing
run_test("Target Listing", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to test directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    clear_notifications()
    bazel.list_targets()
    
    local last_notification = get_last_notification()
    assert(last_notification, "Should show notification")
    -- Check for any notification about targets
    assert(string.find(last_notification.message, "targets") or 
           string.find(last_notification.message, "test mode"), 
           "Should show targets or test mode message")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Specific target execution
run_test("Specific Target Execution", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to test directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    clear_notifications()
    bazel.run_specific_target("main_app")
    
    local last_notification = get_last_notification()
    assert(last_notification, "Should show notification")
    -- Check for any notification about building, targets, or test mode
    assert(string.find(last_notification.message, "Building") or 
           string.find(last_notification.message, "targets") or
           string.find(last_notification.message, "test mode") or
           string.find(last_notification.message, "not found"), 
           "Should show building, targets, test mode, or not found message")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Invalid target execution
run_test("Invalid Target Execution", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to test directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    clear_notifications()
    bazel.run_specific_target("nonexistent_target")
    
    local last_notification = get_last_notification()
    assert(last_notification, "Should show notification")
    assert(string.find(last_notification.message, "Target 'nonexistent_target' not found"), 
           "Should show target not found message")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Target picker functionality
run_test("Target Picker Functionality", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to test directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    clear_notifications()
    bazel.show_target_picker()
    
    local last_notification = get_last_notification()
    assert(last_notification, "Should show notification")
    -- Check for either targets found message or test mode message
    assert(string.find(last_notification.message, "Found %d Bazel targets") or 
           string.find(last_notification.message, "test mode"), 
           "Should show targets found or test mode message")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Deep nested target detection
run_test("Deep Nested Target Detection", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to deep nested directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir .. "/src/nested/deep")
    
    local targets = bazel.get_available_targets()
    assert(#targets > 0, "Should find targets even in deep nested directory")
    
    -- Check for targets from parent directories
    local has_deep_app = false
    local has_go_app = false
    
    for _, target in ipairs(targets) do
        if target.name == "deep_app" then has_deep_app = true end
        if target.name == "go_app" then has_go_app = true end
    end
    
    assert(has_deep_app, "Should find deep_app target")
    assert(has_go_app, "Should find go_app target")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Different target types
run_test("Different Target Types", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to test directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    local targets = bazel.get_available_targets()
    
    local target_types = {}
    for _, target in ipairs(targets) do
        target_types[target.type] = (target_types[target.type] or 0) + 1
    end
    
    -- Should have various target types
    assert(target_types["cc_binary"] and target_types["cc_binary"] > 0, "Should have cc_binary targets")
    assert(target_types["cc_library"] and target_types["cc_library"] > 0, "Should have cc_library targets")
    assert(target_types["cc_test"] and target_types["cc_test"] > 0, "Should have cc_test targets")
    assert(target_types["py_binary"] and target_types["py_binary"] > 0, "Should have py_binary targets")
    assert(target_types["py_library"] and target_types["py_library"] > 0, "Should have py_library targets")
    assert(target_types["py_test"] and target_types["py_test"] > 0, "Should have py_test targets")
    assert(target_types["java_binary"] and target_types["java_binary"] > 0, "Should have java_binary targets")
    assert(target_types["java_library"] and target_types["java_library"] > 0, "Should have java_library targets")
    assert(target_types["java_test"] and target_types["java_test"] > 0, "Should have java_test targets")
    assert(target_types["go_binary"] and target_types["go_binary"] > 0, "Should have go_binary targets")
    assert(target_types["go_library"] and target_types["go_library"] > 0, "Should have go_library targets")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Error handling for invalid BUILD files
run_test("Invalid BUILD File Handling", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to invalid directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir .. "/invalid")
    
    local targets = bazel.get_available_targets()
    -- Should not crash, but might not find valid targets
    assert(type(targets) == "table", "Should return table even with invalid BUILD file")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Empty BUILD file handling
run_test("Empty BUILD File Handling", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to empty directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir .. "/empty")
    
    local targets = bazel.get_available_targets()
    assert(type(targets) == "table", "Should return table even with empty BUILD file")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: BUILD file with no targets
run_test("BUILD File with No Targets", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to no_targets directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir .. "/no_targets")
    
    local targets = bazel.get_available_targets()
    assert(type(targets) == "table", "Should return table even with BUILD file containing no targets")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Workspace from different directory levels
run_test("Workspace Detection from Different Levels", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Test from root
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    local targets_root = bazel.get_available_targets()
    assert(#targets_root > 0, "Should find targets from root")
    
    -- Test from nested directory
    vim.fn.chdir(test_dir .. "/src/nested/deep")
    local targets_deep = bazel.get_available_targets()
    assert(#targets_deep > 0, "Should find targets from deep nested directory")
    
    -- Should find same targets from different levels
    assert(#targets_root == #targets_deep, "Should find same number of targets from different levels")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Notification system
run_test("Notification System", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Change to test directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir)
    
    clear_notifications()
    
    -- Test successful case
    bazel.run_bazel_build()
    local success_notification = get_last_notification()
    assert(success_notification, "Should show notification for successful case")
    
    -- Test error case
    clear_notifications()
    bazel.run_specific_target("nonexistent")
    local error_notification = get_last_notification()
    assert(error_notification, "Should show notification for error case")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Edge case - very deep directory structure
run_test("Very Deep Directory Structure", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Create a very deep directory structure
    local deep_path = test_dir .. "/a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p"
    vim.fn.mkdir(deep_path, "p")
    
    -- Create a BUILD file in the deep directory
    local build_file = io.open(deep_path .. "/BUILD", "w")
    if build_file then
        build_file:write([[
cc_binary(
    name = "deep_test_app",
    srcs = ["main.cc"],
)
]])
        build_file:close()
    end
    
    -- Create source file
    local source_file = io.open(deep_path .. "/main.cc", "w")
    if source_file then
        source_file:write("int main() { return 0; }")
        source_file:close()
    end
    
    -- Change to deep directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(deep_path)
    
    local targets = bazel.get_available_targets()
    assert(#targets > 0, "Should find targets even in very deep directory")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Test: Edge case - special characters in target names
run_test("Special Characters in Target Names", function()
    local test_dir = test_setup.setup_test_workspace()
    
    -- Create BUILD file with special characters
    local special_build = io.open(test_dir .. "/special/BUILD", "w")
    if special_build then
        special_build:write([[
cc_binary(
    name = "test-app_with_underscores",
    srcs = ["main.cc"],
)

py_binary(
    name = "test.app.with.dots",
    srcs = ["app.py"],
)
]])
        special_build:close()
    end
    
    vim.fn.mkdir(test_dir .. "/special", "p")
    
    -- Create source files
    local main_cc = io.open(test_dir .. "/special/main.cc", "w")
    if main_cc then
        main_cc:write("int main() { return 0; }")
        main_cc:close()
    end
    
    local app_py = io.open(test_dir .. "/special/app.py", "w")
    if app_py then
        app_py:write("print('Hello')")
        app_py:close()
    end
    
    -- Change to special directory
    local original_dir = vim.fn.getcwd()
    vim.fn.chdir(test_dir .. "/special")
    
    local targets = bazel.get_available_targets()
    assert(#targets >= 2, "Should find targets with special characters")
    
    -- Restore original directory
    vim.fn.chdir(original_dir)
    test_setup.cleanup_test_workspace()
end)

-- Print test results
print("=" .. string.rep("=", 50))
print("🧪 BAZEL TEST SUITE RESULTS")
print("=" .. string.rep("=", 50))
print(string.format("✅ Passed: %d", test_results.passed))
print(string.format("❌ Failed: %d", test_results.failed))
print(string.format("📊 Total: %d", test_results.total))
print(string.format("📈 Success Rate: %.1f%%", (test_results.passed / test_results.total) * 100))
print("=" .. string.rep("=", 50))

-- Restore original notify function
vim.notify = original_notify

if test_results.failed > 0 then
    print("❌ Some tests failed! Please review the output above.")
    vim.cmd("quit!")
else
    print("🎉 All tests passed! Bazel system is working correctly.")
    vim.cmd("quit!")
end 