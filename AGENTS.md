# AGENTS.md

## Build/Lint/Test Commands
- **Format Lua code**: `stylua .` (uses config in `.stylua.toml`, installed via Mason)
- **No test suite**: This is a Neovim configuration (kickstart.nvim), not a software project with tests
- **Check config**: Start `nvim` and run `:checkhealth` to verify setup

## Code Style Guidelines

### Lua Formatting (via .stylua.toml)
- **Indentation**: 2 spaces, no tabs
- **Line width**: 160 characters max
- **Quotes**: Auto-prefer single quotes
- **Function calls**: No parentheses when possible (`require 'module'` not `require('module')`)

### Naming Conventions
- **Variables/functions**: `snake_case` (e.g., `local my_variable`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `vim.g.have_nerd_font`)
- **Plugin configs**: Use descriptive names matching plugin purpose

### Code Organization
- **Imports**: Use `require 'module'` style, group at top of functions
- **Plugin setup**: Return table from plugin files in `lua/custom/plugins/`
- **Comments**: Use `--` for single line, document complex configurations
- **String literals**: Prefer single quotes unless containing single quotes