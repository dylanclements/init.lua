# Bazel Test Suite

This directory contains a comprehensive test suite for the Bazel build system integration in Neovim.

## 🧪 Test Structure

### Files

- **`bazel_test_setup.lua`** - Test setup and mock workspace creation
- **`bazel_tests.lua`** - Main test suite with all test cases
- **`run_bazel_tests.sh`** - Test runner script
- **`test_bazel.lua`** - Documentation and usage examples

## 🚀 Running Tests

### Quick Start

```bash
./test/run_bazel_tests.sh
```

### Manual Testing

```bash
nvim --headless --noplugin -c "lua require('test.bazel_tests')" -c "quit"
```

## 📋 Test Coverage

### Core Functionality Tests

1. **Workspace Detection**

   - ✅ Valid Bazel workspace detection
   - ✅ Non-Bazel workspace detection
   - ✅ Workspace detection from different directory levels

2. **Target Extraction**

   - ✅ Multiple target types (cc_binary, py_binary, java_binary, etc.)
   - ✅ Target path construction
   - ✅ Deep nested target detection
   - ✅ Different target types validation

3. **Build System**

   - ✅ Single target scenario
   - ✅ Multiple targets scenario (picker)
   - ✅ No targets scenario
   - ✅ Invalid target execution
   - ✅ Specific target execution

4. **Interactive Features**
   - ✅ Target picker functionality
   - ✅ Target listing
   - ✅ Command selection (build/test/run)

### Edge Case Tests

1. **Error Handling**

   - ✅ Invalid BUILD files
   - ✅ Empty BUILD files
   - ✅ BUILD files with no targets
   - ✅ Non-Bazel workspaces

2. **Directory Structure**

   - ✅ Very deep directory structures
   - ✅ Special characters in target names
   - ✅ Nested directory hierarchies

3. **Notification System**
   - ✅ Success notifications
   - ✅ Error notifications
   - ✅ Warning notifications

## 🏗️ Mock Workspace Structure

The test suite creates a comprehensive mock Bazel workspace:

```
bazel_test_workspace/
├── WORKSPACE
├── BUILD (root level targets)
├── src/
│   ├── BUILD (binary targets)
│   ├── nested/
│   │   ├── BUILD (library targets)
│   │   └── deep/
│   │       └── BUILD (deep nested targets)
├── test/
│   └── BUILD (test targets)
├── invalid/
│   └── BUILD (invalid targets)
├── empty/
│   └── BUILD (empty file)
└── no_targets/
    └── BUILD (no targets defined)
```

### Target Types Tested

- **C++**: `cc_binary`, `cc_library`, `cc_test`
- **Python**: `py_binary`, `py_library`, `py_test`
- **Java**: `java_binary`, `java_library`, `java_test`
- **Go**: `go_binary`, `go_library`

## 🔧 Test Utilities

### Mock Functions

- **`setup_test_workspace()`** - Creates complete mock workspace
- **`create_minimal_workspace()`** - Creates workspace with no targets
- **`create_non_bazel_workspace()`** - Creates non-Bazel workspace
- **`cleanup_test_workspace()`** - Cleans up test files
- **`change_to_test_dir()`** - Changes to test directory
- **`restore_original_dir()`** - Restores original directory

### Test Helpers

- **`run_test(name, func)`** - Runs individual test with error handling
- **`assert(condition, message)`** - Custom assertion function
- **`clear_notifications()`** - Clears captured notifications
- **`get_last_notification()`** - Gets last notification for verification

## 📊 Test Results

The test suite provides detailed results:

```
==================================================
🧪 BAZEL TEST SUITE RESULTS
==================================================
✅ Passed: 18
❌ Failed: 0
📊 Total: 18
📈 Success Rate: 100.0%
==================================================
🎉 All tests passed! Bazel system is working correctly.
```

## 🐛 Debugging Tests

### Common Issues

1. **Permission Errors**: Ensure test runner is executable

   ```bash
   chmod +x test/run_bazel_tests.sh
   ```

2. **Neovim Not Found**: Install Neovim or update PATH

   ```bash
   which nvim
   ```

3. **Module Not Found**: Ensure you're in the correct directory
   ```bash
   pwd  # Should be in nvim config root
   ls lua/dylanclements/bazel.lua  # Should exist
   ```

### Verbose Testing

For detailed output, run tests manually:

```bash
nvim --headless --noplugin -c "lua require('test.bazel_tests')" -c "quit" 2>&1 | tee test_output.log
```

## 🔄 Continuous Integration

The test suite is designed to be CI-friendly:

- ✅ No external dependencies (except Neovim)
- ✅ Self-contained mock data
- ✅ Automatic cleanup
- ✅ Clear exit codes (0 for success, 1 for failure)
- ✅ Comprehensive error reporting

## 📝 Adding New Tests

To add new tests:

1. **Add test function** in `bazel_tests.lua`:

   ```lua
   run_test("New Test Name", function()
       -- Test logic here
       assert(condition, "Error message")
   end)
   ```

2. **Add mock data** in `bazel_test_setup.lua` if needed

3. **Run tests** to verify:
   ```bash
   ./test/run_bazel_tests.sh
   ```

## 🎯 Test Philosophy

- **Comprehensive**: Tests all major functionality and edge cases
- **Isolated**: Each test is independent and self-contained
- **Realistic**: Uses realistic Bazel workspace structures
- **Maintainable**: Clear structure and documentation
- **Fast**: Minimal setup/teardown overhead
