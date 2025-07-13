# Avante.nvim Setup Guide

## Installation

Avante.nvim has been successfully installed in your Neovim configuration. The plugin is configured to use lazy.nvim for management.

## Configuration

The plugin is configured with the following settings:

### Provider Configuration

- **Default Provider**: Claude (Anthropic)
- **Model**: claude-sonnet-4-20250514
- **Timeout**: 30 seconds
- **Temperature**: 0.75
- **Max Tokens**: 20,480

### Key Bindings

All keybindings use `<leader>` (space bar) as the prefix:

#### Sidebar Controls

- `<leader>aa` - Show/toggle Avante sidebar
- `<leader>at` - Toggle sidebar visibility
- `<leader>ar` - Refresh sidebar
- `<leader>af` - Switch sidebar focus

#### AI Interactions

- `<leader>a?` - Select AI model/provider
- `<leader>an` - New ask (start a new conversation)
- `<leader>ae` - Edit selected code blocks
- `<leader>aS` - Stop current AI request
- `<leader>ah` - View chat history

#### File Management

- `<leader>ac` - Add current buffer to selected files
- `<leader>aB` - Add all buffer files to selected files
- `<leader>a+` - Select file in NvimTree (if available)
- `<leader>a-` - Deselect file in NvimTree (if available)

#### Repository & Debug

- `<leader>aR` - Show repository map
- `<leader>ad` - Toggle debug mode
- `<leader>as` - Toggle suggestion display

## Environment Variables

You need to set up API keys for the AI providers. Avante supports scoped API keys (recommended):

### Scoped API Keys (Recommended)

```bash
# Add these to your shell profile (~/.zshrc, ~/.bashrc, etc.)
export AVANTE_ANTHROPIC_API_KEY=your-claude-api-key
export AVANTE_OPENAI_API_KEY=your-openai-api-key
export AVANTE_AZURE_OPENAI_API_KEY=your-azure-api-key
```

### Global API Keys (Legacy)

```bash
export ANTHROPIC_API_KEY=your-claude-api-key
export OPENAI_API_KEY=your-openai-api-key
```

## Usage

### Basic Commands

1. **Start a conversation**: Press `<leader>an` or use `:AvanteAsk`
2. **Ask about current file**: `:AvanteAsk @file what are the issues in this code?`
3. **Ask about entire codebase**: `:AvanteAsk @codebase explain the project structure`
4. **Get help with diagnostics**: `:AvanteAsk @diagnostics how do I fix these errors?`

### @mentions

Avante supports several @mentions for context:

- `@codebase` - Include entire codebase context
- `@diagnostics` - Include current diagnostic issues
- `@file` - Include current file
- `@quickfix` - Include quickfix list
- `@buffers` - Include all open buffers

### Example Usage

```vim
" Ask about the current file
:AvanteAsk @file what are the issues in this code?

" Ask about the entire project
:AvanteAsk @codebase explain the project structure

" Get help with errors
:AvanteAsk @diagnostics how do I fix these errors?

" Start a new chat session
:AvanteChat

" Edit selected code
:AvanteEdit
```

## Features

### AI-Powered Code Assistance

- Interact with AI to ask questions about your code
- Receive intelligent suggestions for improvements
- Apply changes directly to your source code

### One-Click Application

- Quickly apply AI suggestions with simple commands
- Streamlined editing process
- Time-saving workflow

### File Management

- Select files for context
- Integrate with NvimTree
- Manage multiple files in conversations

### Web Search Integration

- Built-in web search capabilities
- Support for multiple search engines (Tavily, Google, etc.)

## Dependencies

The following plugins are automatically installed as dependencies:

- `nvim-lua/plenary.nvim` - Required utility library
- `MunifTanjim/nui.nvim` - UI components
- `nvim-telescope/telescope.nvim` - File selection
- `hrsh7th/nvim-cmp` - Autocompletion
- `nvim-tree/nvim-web-devicons` - Icons
- And more for enhanced functionality

## Troubleshooting

### Common Issues

1. **API Key Not Found**: Make sure you've set the environment variables correctly
2. **Build Errors**: The plugin should automatically download prebuilt binaries
3. **Key Bindings Not Working**: Ensure your leader key is set to space (already configured)

### Getting Help

- Check the [official avante.nvim documentation](https://github.com/yetone/avante.nvim)
- Use `:AvanteHelp` for built-in help
- Check `:checkhealth avante` for health diagnostics

## Next Steps

1. Set up your API keys in your shell profile
2. Restart Neovim to load the plugin
3. Try `<leader>an` to start your first conversation
4. Explore the sidebar with `<leader>aa`

Enjoy using Avante.nvim for AI-powered coding assistance!
