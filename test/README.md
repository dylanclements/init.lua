# Neovim Configuration Tests

This directory contains test scripts for validating the Neovim configuration.

## Test Scripts

### `test_remaps.sh`

- **Purpose**: Checks for duplicate keybindings in the Neovim configuration
- **Usage**: `./test_remaps.sh`
- **What it does**:
  - Scans all Lua files in the `lua/` directory
  - Extracts all `vim.keymap.set()` calls
  - Identifies any duplicate keybindings
  - Reports conflicts with file locations

### `test_nvim_startup.sh`

- **Purpose**: Tests Neovim startup time and validates configuration
- **Usage**: `./test_nvim_startup.sh`
- **What it does**:
  - Measures startup time
  - Validates that Neovim starts without errors
  - Checks for configuration issues

## Running Tests

From the root directory:

```bash
# Test for duplicate keybindings
./test/test_remaps.sh

# Test Neovim startup
./test/test_nvim_startup.sh
```

## Adding New Tests

When adding new test scripts:

1. Place them in this `test/` directory
2. Make them executable: `chmod +x test/your_test.sh`
3. Document them in this README
4. Consider adding them to CI/CD pipelines
