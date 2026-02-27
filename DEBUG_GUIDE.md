# C# Debugging Guide for Neovim

## Installed Tools
- **netcoredbg**: C# debugger (located at `~/.local/bin/netcoredbg`)
- **dotnet-lambda-test-tool-6.0**: AWS Lambda mock test tool

## Quick Start

### 1. Set Breakpoints
- `<leader>bb` - Toggle breakpoint on current line
- `<leader>bc` - Set conditional breakpoint (e.g., `i == 5`)
- `<leader>bl` - Set log point (logs without stopping)

### 2. Start Debugging
Press `<F5>` to start debugging. You'll see these options:
1. **Launch** - Manually specify DLL path
2. **Launch - Auto detect DLL** - Automatically finds your built DLL
3. **Attach** - Attach to a running process
4. **Lambda Mock Test Tool** - Run Lambda functions locally with web UI

### 3. Debug Controls
- `<F5>` - Continue execution
- `<F10>` - Step over (next line)
- `<F11>` - Step into (go inside function)
- `<F12>` - Step out (exit current function)
- `<leader>dx` - Stop debugging

### 4. Inspect Variables
- Hover over variables to see values (inline display enabled)
- `<leader>dv` - Evaluate expression under cursor
- `<leader>du` - Toggle debug UI sidebar (shows variables, call stack, watches)
- `<leader>ds` - Show scopes in floating window

## AWS Lambda Testing

When you select "Lambda Mock Test Tool":
1. Enter port (default: 5050)
2. Tool starts at http://localhost:5050
3. Open the URL in your browser
4. Select your Lambda function and test with sample events
5. Set breakpoints in your code - they'll be hit when you invoke the function

## Debug UI Layout

The debug UI has two panels:
- **Left panel**: Scopes, Breakpoints, Call Stack, Watches
- **Bottom panel**: REPL, Console output

## All Debug Keybindings

### Breakpoints
- `<leader>bb` - Toggle breakpoint
- `<leader>bc` - Conditional breakpoint
- `<leader>bl` - Log point
- `<leader>br` - Clear all breakpoints
- `<leader>ba` - List breakpoints (Telescope)

### Execution Control
- `<F5>` or `<leader>dc` - Start/Continue
- `<F10>` or `<leader>dO` - Step over
- `<F11>` or `<leader>di` - Step into
- `<F12>` or `<leader>do` - Step out
- `<leader>dp` - Pause
- `<leader>dl` - Run last configuration
- `<leader>dx` - Stop debugging
- `<leader>dq` - Close session
- `<leader>dQ` - Terminate forcefully

### Inspection
- `<leader>dh` - Hover variables
- `<leader>dv` - Evaluate expression (normal/visual mode)
- `<leader>ds` - Show scopes
- `<leader>df` - Show frames
- `<leader>du` - Toggle UI
- `<leader>dR` - Toggle REPL

### Navigation
- `<leader>dj` - Down stack frame
- `<leader>dk` - Up stack frame

### Telescope Integration
- `<leader>dC` - Browse debug configurations
- `<leader>dB` - List breakpoints
- `<leader>dV` - Browse variables
- `<leader>dF` - Browse frames

## Tips

1. **Auto-detect works best** - Use "Launch - Auto detect DLL" for most projects
2. **Build first** - Always build your project before debugging (`<leader>db`)
3. **Inline values** - Variable values appear inline while debugging
4. **REPL** - Use `<leader>dR` to open REPL and evaluate expressions on the fly
5. **Lambda testing** - Great for local AWS Lambda development without deploying

## Troubleshooting

If debugging doesn't start:
1. Ensure your project is built: `<leader>db`
2. Check the DLL path is correct
3. Verify netcoredbg is in PATH: `~/.local/bin/netcoredbg --version`
4. Check console output in the debug UI for errors
