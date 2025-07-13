-- Test file for Bazel functionality
-- This file demonstrates how the Bazel build system works

-- Mock Bazel workspace structure for testing:
-- /workspace_root/
--   WORKSPACE
--   BUILD
--   src/
--     BUILD
--     main.cc
--   test/
--     BUILD
--     test.cc

-- Example BUILD file content for src/BUILD:
-- cc_binary(
--     name = "my_app",
--     srcs = ["main.cc"],
--     deps = ["//:common_lib"],
-- )

-- Example BUILD file content for test/BUILD:
-- cc_test(
--     name = "my_test",
--     srcs = ["test.cc"],
--     deps = ["//src:my_app"],
-- )

-- Usage:
-- 1. <leader>bb - Run Bazel build for current target (shows picker if multiple targets)
-- 2. <leader>bl - List all Bazel targets in quickfix window
-- 3. <leader>bt - Run specific Bazel target by name
-- 4. <leader>bp - Interactive target picker with build/test/run options

-- The system will:
-- - Detect if you're in a Bazel workspace (looks for WORKSPACE file)
-- - Find BUILD files in current and parent directories
-- - Extract target information from BUILD files
-- - Show interactive picker when multiple targets are available
-- - Support build, test, and run commands
-- - Open a vertical split terminal and run the selected command
-- - Show appropriate notifications for success/failure

print("Bazel build system test file")
print("Use <leader>bb to test the build functionality") 