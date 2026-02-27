# Complete C# Lambda Debugging Setup - Summary

## ✅ What Was Installed

1. **netcoredbg** - C# debugger at `~/.local/bin/netcoredbg`
2. **nvim-dap** - Debug Adapter Protocol plugin with UI
3. **nvim-dap-ui** - Visual debug interface
4. **nvim-dap-virtual-text** - Inline variable display
5. **telescope-dap** - Debug navigation integration
6. **Environment variable support** - Automatic `.env.lambda` file loading

## ✅ What Was Configured

1. **Breakpoint signs** - Visible red ● markers
2. **Lambda Test Tool** - .NET 8.0 version configured
3. **Working directory** - Auto-detection of Lambda function path
4. **Environment variables** - Automatic loading from `.env.lambda`
5. **Debug configurations** - Multiple launch options

## 📁 Files Created

- `~/.config/nvim/lua/custom/plugins/nvim-dap.lua` - Main debug configuration
- `~/.config/nvim/DEBUG_GUIDE.md` - General debugging guide
- `~/.config/nvim/lambda-debug-guide.md` - Lambda-specific guide
- `~/.config/nvim/env-vars-guide.md` - Environment variables guide
- `/path/to/lambda/function/.env.lambda` - Your environment variables
- `/path/to/lambda/function/.env.lambda.template` - Template for team

## 🚀 Quick Start

### Option 1: Quick Lambda Debug (Recommended)

1. Open a file in your Lambda function directory
2. Press `<leader>dL` to start Lambda Test Tool
3. Set breakpoints with `<leader>bb`
4. Open http://localhost:5050 and execute your function
5. Breakpoints will be hit automatically!

### Option 2: Using F5 Debug Menu

1. Set breakpoints with `<leader>bb`
2. Press `<F5>` 
3. Choose "Lambda Test Tool - Launch"
4. Open http://localhost:5050 and execute

## 🔑 Important Keybindings

### Breakpoints
- `<leader>bb` - Toggle breakpoint
- `<leader>bc` - Conditional breakpoint
- `<leader>br` - Clear all breakpoints

### Debug Control
- `<F5>` - Start/Continue
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out
- `<leader>dx` - Stop debugging

### Inspection
- Hover mouse - See variable values
- `<leader>dv` - Evaluate expression
- `<leader>du` - Toggle debug UI
- `<leader>dh` - Hover variables

### Lambda Tool
- `<leader>dL` - Start Lambda Test Tool with env vars

## 🔐 Environment Variables

Your `.env.lambda` file is located at:
```
/Users/murilo.preccaro/Documents/GitHub/pim-oracle-sync-acl/src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer/.env.lambda
```

It contains:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN
- ORACLESETTINGS__PASSWORD
- ORACLESETTINGS__USERNAME
- ASPNETCORE_ENVIRONMENT

**Important**: This file is gitignored. Update credentials when they expire.

## 🔄 To Update AWS Credentials

When your AWS session expires:

1. Get new credentials from AWS SSO
2. Edit the `.env.lambda` file:
   ```bash
   nvim src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer/.env.lambda
   ```
3. Update the three AWS variables
4. Restart the Lambda Test Tool

## 📋 Complete Workflow Example

```
1. cd /Users/murilo.preccaro/Documents/GitHub/pim-oracle-sync-acl
2. nvim src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer/Function.cs
3. <leader>bb          (set breakpoint in handler)
4. <leader>dL          (start Lambda tool - loads env vars automatically)
5. Press Enter         (use default port 5050)
6. Open browser to http://localhost:5050
7. Select your function
8. Create/select test event
9. Execute function
10. Breakpoint hits! 🎯
11. <F10>             (step through code)
12. Hover variables   (inspect values)
13. <F5>              (continue)
14. <leader>dx        (stop when done)
```

## 📚 Documentation

All guides are in your Neovim config directory:
- `~/.config/nvim/DEBUG_GUIDE.md` - General debugging
- `~/.config/nvim/lambda-debug-guide.md` - Lambda debugging
- `~/.config/nvim/env-vars-guide.md` - Environment variables

## 🔍 Verification

After restarting Neovim, verify everything works:

1. **Check DAP loaded**:
   ```vim
   :lua print(pcall(require, 'dap'))
   ```
   Should output: `true`

2. **Test breakpoint**:
   - Open a .cs file
   - Press `<leader>bb`
   - You should see a red ● in the gutter

3. **Test env loading**:
   - Press `<leader>dL`
   - Check notifications - should say "Loaded 6 environment variables"

## 🆘 Troubleshooting

### Breakpoints not showing
- Restart Neovim
- Run `:checkhealth dap`

### Environment variables not loading
- Check file exists: `ls -la /path/to/function/.env.lambda`
- Check file format (KEY=VALUE, no extra spaces)

### Lambda tool won't start
- Verify DLL path exists
- Check working directory is correct
- Look at terminal output for errors

## 🎉 You're All Set!

Everything is configured to match your Rider setup. The debugging experience should be very similar, with breakpoints, variable inspection, and step-through debugging all working smoothly.

Happy debugging! 🐛🔨
