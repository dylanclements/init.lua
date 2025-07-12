# Neovim Configuration

My personal Neovim configuration with a focus on productivity and modern development workflows.

## Features

- **Lazy.nvim** for plugin management
- **LSP** support for multiple languages
- **Telescope** for fuzzy finding
- **Treesitter** for better syntax highlighting
- **Bufferline** for tab management
- **Nvim-tree** for file explorer
- **Git integration** with fugitive and gitsigns
- **And much more...**

## Testing

This configuration includes a comprehensive test suite to ensure everything works correctly:

### Running Tests

```bash
# Run all tests
./test.sh

# Run individual tests
./test_nvim_startup.sh  # Test Neovim startup
./test_remaps.sh        # Check for duplicate keybindings
```

### Test Coverage

- **Startup Test**: Verifies Neovim starts without errors
- **Keybinding Test**: Checks for duplicate keybindings across all Lua files

### Adding New Tests

To add a new test, simply create a file named `test_*.sh` in the repository root. The test orchestrator will automatically find and run it.

---

_I use vim btw_
