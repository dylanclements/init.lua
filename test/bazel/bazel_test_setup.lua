local M = {}

-- Test directory structure
local test_dir = vim.fn.tempname() .. "/bazel_test_workspace"
local original_cwd = vim.fn.getcwd()

-- Mock Bazel workspace structure
local mock_workspace = {
    -- Root level
    ["WORKSPACE"] = [[
workspace(name = "test_workspace")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_cc",
    urls = ["https://github.com/bazelbuild/rules_cc/releases/download/0.0.9/rules_cc-0.0.9.tar.gz"],
    sha256 = "2037875b9a4456dce4a79d112a8ae885bbc4aad968e6587dca6e64f3a7450db",
)
]],

    -- Root BUILD file
    ["BUILD"] = [[
cc_library(
    name = "common_lib",
    srcs = ["common.cc"],
    hdrs = ["common.h"],
    visibility = ["//visibility:public"],
)

py_library(
    name = "utils",
    srcs = ["utils.py"],
    visibility = ["//visibility:public"],
)

java_library(
    name = "base_utils",
    srcs = ["BaseUtils.java"],
    visibility = ["//visibility:public"],
)
]],

    -- Source directory
    ["src/BUILD"] = [[
cc_binary(
    name = "main_app",
    srcs = ["main.cc"],
    deps = ["//:common_lib"],
)

cc_binary(
    name = "secondary_app",
    srcs = ["secondary.cc"],
    deps = ["//:common_lib"],
)

py_binary(
    name = "python_app",
    srcs = ["app.py"],
    deps = ["//:utils"],
)

java_binary(
    name = "java_app",
    srcs = ["App.java"],
    deps = ["//:base_utils"],
    main_class = "com.example.App",
)
]],

    -- Test directory
    ["test/BUILD"] = [[
cc_test(
    name = "unit_tests",
    srcs = ["test_main.cc"],
    deps = ["//src:main_app"],
)

cc_test(
    name = "integration_tests",
    srcs = ["integration_test.cc"],
    deps = ["//src:main_app", "//src:secondary_app"],
)

py_test(
    name = "python_tests",
    srcs = ["test_app.py"],
    deps = ["//src:python_app"],
)

java_test(
    name = "java_tests",
    srcs = ["AppTest.java"],
    deps = ["//src:java_app"],
)
]],

    -- Nested directory
    ["src/nested/BUILD"] = [[
cc_library(
    name = "nested_lib",
    srcs = ["nested.cc"],
    hdrs = ["nested.h"],
    deps = ["//:common_lib"],
)

go_library(
    name = "go_utils",
    srcs = ["utils.go"],
    importpath = "example.com/utils",
)
]],

    -- Deep nested directory
    ["src/nested/deep/BUILD"] = [[
cc_binary(
    name = "deep_app",
    srcs = ["deep_main.cc"],
    deps = ["//src/nested:nested_lib"],
)

go_binary(
    name = "go_app",
    srcs = ["main.go"],
    deps = ["//src/nested:go_utils"],
)
]],

    -- Invalid BUILD file (for testing error cases)
    ["invalid/BUILD"] = [[
invalid_target(
    name = "broken_target",
    srcs = ["broken.cc"],
)
]],

    -- Empty BUILD file
    ["empty/BUILD"] = "",

    -- BUILD file with no targets
    ["no_targets/BUILD"] = [[
# This is a comment
# No targets defined here
]],
}

-- Mock source files (to make the workspace more realistic)
local mock_source_files = {
    ["common.cc"] = [[
#include "common.h"
int common_function() { return 42; }
]],
    ["common.h"] = [[
#ifndef COMMON_H
#define COMMON_H
int common_function();
#endif
]],
    ["utils.py"] = [[
def utility_function():
    return "Hello from utils"
]],
    ["BaseUtils.java"] = [[
package com.example;
public class BaseUtils {
    public static String getMessage() {
        return "Hello from BaseUtils";
    }
}
]],
    ["src/main.cc"] = [[
#include "common.h"
int main() { return common_function(); }
]],
    ["src/secondary.cc"] = [[
#include "common.h"
int secondary_main() { return common_function() * 2; }
]],
    ["src/app.py"] = [[
from utils import utility_function
print(utility_function())
]],
    ["src/App.java"] = [[
package com.example;
public class App {
    public static void main(String[] args) {
        System.out.println(BaseUtils.getMessage());
    }
}
]],
    ["test/test_main.cc"] = [[
#include "gtest/gtest.h"
TEST(UnitTest, Basic) { EXPECT_EQ(1, 1); }
]],
    ["test/integration_test.cc"] = [[
#include "gtest/gtest.h"
TEST(IntegrationTest, Basic) { EXPECT_EQ(2, 2); }
]],
    ["test/test_app.py"] = [[
import unittest
class TestApp(unittest.TestCase):
    def test_basic(self):
        self.assertEqual(1, 1)
]],
    ["test/AppTest.java"] = [[
package com.example;
import org.junit.Test;
public class AppTest {
    @Test
    public void testBasic() {
        // Test implementation
    }
}
]],
    ["src/nested/nested.cc"] = [[
#include "nested.h"
int nested_function() { return 100; }
]],
    ["src/nested/nested.h"] = [[
#ifndef NESTED_H
#define NESTED_H
int nested_function();
#endif
]],
    ["src/nested/utils.go"] = [[
package utils
func GetValue() int { return 42 }
]],
    ["src/nested/deep/deep_main.cc"] = [[
#include "nested.h"
int main() { return nested_function(); }
]],
    ["src/nested/deep/main.go"] = [[
package main
import "example.com/utils"
func main() { utils.GetValue() }
]],
    ["invalid/broken.cc"] = [[
int main() { return 0; }
]],
}

-- Function to create the mock workspace
function M.setup_test_workspace()
    -- Create test directory
    vim.fn.mkdir(test_dir, "p")
    
    -- Create all directories
    local dirs = {
        "src",
        "test", 
        "src/nested",
        "src/nested/deep",
        "invalid",
        "empty",
        "no_targets"
    }
    
    for _, dir in ipairs(dirs) do
        vim.fn.mkdir(test_dir .. "/" .. dir, "p")
    end
    
    -- Create all files
    for file_path, content in pairs(mock_workspace) do
        local full_path = test_dir .. "/" .. file_path
        local file = io.open(full_path, "w")
        if file then
            file:write(content)
            file:close()
        end
    end
    
    -- Create source files
    for file_path, content in pairs(mock_source_files) do
        local full_path = test_dir .. "/" .. file_path
        local file = io.open(full_path, "w")
        if file then
            file:write(content)
            file:close()
        end
    end
    
    return test_dir
end

-- Function to cleanup test workspace
function M.cleanup_test_workspace()
    if vim.fn.isdirectory(test_dir) == 1 then
        vim.fn.delete(test_dir, "rf")
    end
end

-- Function to change to test directory
function M.change_to_test_dir()
    vim.fn.chdir(test_dir)
end

-- Function to restore original directory
function M.restore_original_dir()
    vim.fn.chdir(original_cwd)
end

-- Function to get current working directory safely
function M.get_current_dir()
    return vim.fn.getcwd()
end

-- Function to check if directory exists
function M.directory_exists(path)
    return vim.fn.isdirectory(path) == 1
end

-- Function to get test directory path
function M.get_test_dir()
    return test_dir
end

-- Function to create a minimal workspace (for testing no targets case)
function M.create_minimal_workspace()
    local minimal_dir = vim.fn.tempname() .. "/minimal_bazel_workspace"
    vim.fn.mkdir(minimal_dir, "p")
    
    -- Create WORKSPACE file
    local workspace_file = io.open(minimal_dir .. "/WORKSPACE", "w")
    if workspace_file then
        workspace_file:write('workspace(name = "minimal_workspace")\n')
        workspace_file:close()
    end
    
    return minimal_dir
end

-- Function to create workspace without WORKSPACE file (for testing non-bazel case)
function M.create_non_bazel_workspace()
    local non_bazel_dir = vim.fn.tempname() .. "/non_bazel_workspace"
    vim.fn.mkdir(non_bazel_dir, "p")
    
    -- Create a BUILD file but no WORKSPACE
    local build_file = io.open(non_bazel_dir .. "/BUILD", "w")
    if build_file then
        build_file:write([[
cc_binary(
    name = "test_app",
    srcs = ["main.cc"],
)
]])
        build_file:close()
    end
    
    return non_bazel_dir
end

return M 