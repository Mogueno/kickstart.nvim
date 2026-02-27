# C# Debugging Guide for Neovim

Complete guide for debugging C# applications in Neovim, including AWS Lambda functions.

---

## 🎯 Overview

This setup provides two debugging workflows:

1. **Regular C# Projects** - Handled by `easy-dotnet.nvim` plugin (auto-configured)
2. **AWS Lambda Functions** - Custom configuration using Lambda Test Tool + vsdbg

Both workflows use standard `F5` debugging and avoid conflicts.

---

## 📋 Quick Start

### Regular C# Debugging

1. Open any `.cs` file in a regular C# project
2. Set breakpoint: `<leader>bb`
3. Start debugging: `F5`
4. Select `easy-dotnet` configuration
5. Done! Debugger builds project and attaches automatically

### Lambda Function Debugging

1. Navigate to Lambda function directory:
   ```bash
   cd /Users/murilo.preccaro/Documents/GitHub/pim-oracle-sync-acl/src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer
   ```
2. Ensure `Properties/launchSettings.json` has your credentials
3. Open `Function.cs` and set breakpoint: `<leader>bb`
4. Start debugging: `F5`
5. Select `Lambda Test Tool` configuration
6. Open browser: `http://localhost:5050`
7. Execute function in Lambda Test Tool UI
8. Breakpoint hits in Neovim!

---

## 🔧 Setup Details

### Debuggers Used

| Debugger | Used For | Location |
|----------|----------|----------|
| **easy-dotnet backend** | Regular C# projects | Managed by `easy-dotnet.nvim` |
| **vsdbg** | Lambda Test Tool | `~/.vscode/extensions/ms-dotnettools.csharp-2.120.3-darwin-arm64/.debugger/arm64/vsdbg` |

### Why Two Debuggers?

- **easy-dotnet**: Best for regular projects, integrates with build system, auto-detects DLLs
- **vsdbg**: More reliable for Lambda Tool (external executable), official Microsoft debugger

---

## 📁 Configuration Files

### 1. Neovim DAP Configuration

**File:** `~/.config/nvim/lua/custom/plugins/nvim-dap.lua`

**Key sections:**
- DAP UI setup (lines 42-100)
- Virtual text configuration (lines 103-124)
- Breakpoint signs (lines 111-115)
- Lambda adapter: `dap.adapters.lambda_coreclr` (lines 117-123)
- Lambda configuration: `dap.configurations.cs` (lines 125-188)
- Debug keymaps (lines 190-320)

**Note:** Regular C# configurations are NOT in this file - they're auto-registered by easy-dotnet.

### 2. Easy-Dotnet Configuration

**File:** `~/.config/nvim/lua/custom/plugins/easy-dotnet.lua`

**Key setting:**
```lua
debugger = {
  auto_register_dap = true,  -- Line 78
}
```

This automatically creates an `easy-dotnet` DAP configuration for regular C# projects.

### 3. Lambda Environment Variables

**File:** `Properties/launchSettings.json` (inside Lambda project)

**Structure:**
```json
{
  "profiles": {
    "Lambda Test Tool": {
      "commandName": "Executable",
      "executablePath": "dotnet",
      "commandLineArgs": "~/.dotnet/tools/.store/.../Amazon.Lambda.TestTool.BlazorTester.dll --port 5050",
      "workingDirectory": "$(ProjectDir)",
      "environmentVariables": {
        "AWS_ACCESS_KEY_ID": "...",
        "AWS_SECRET_ACCESS_KEY": "...",
        "AWS_SESSION_TOKEN": "...",
        "ORACLESETTINGS__PASSWORD": "...",
        "ORACLESETTINGS__USERNAME": "...",
        "AWS_REGION": "eu-west-1",
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

**Important:**
- This file contains **secrets** - it's gitignored
- Copy from `launchSettings.json.template` to get started
- Update credentials when AWS session expires
- Works with Rider, VSCode, and Neovim (standard .NET format)

---

## ⌨️ Keybindings

### Debug Control

| Keymap | Action | Description |
|--------|--------|-------------|
| `F5` | Start/Continue | Start debugging or continue execution |
| `F10` | Step Over | Execute current line, step over function calls |
| `F11` | Step Into | Step into function call |
| `F12` | Step Out | Step out of current function |

### Breakpoints

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>bb` | Toggle Breakpoint | Add/remove breakpoint on current line |
| `<leader>bc` | Conditional Breakpoint | Set breakpoint with condition |
| `<leader>bl` | Log Point | Set log point (doesn't break, just logs) |
| `<leader>br` | Clear All Breakpoints | Remove all breakpoints |
| `<leader>ba` | List Breakpoints | Show all breakpoints (Telescope) |

### Debug UI

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>du` | Toggle Debug UI | Open/close DAP UI panels |
| `<leader>dR` | Toggle REPL | Open REPL for expression evaluation |
| `<leader>dh` | Hover Variables | Show variable value under cursor |
| `<leader>dv` | Evaluate Expression | Evaluate selected expression |
| `<leader>ds` | Show Scopes | Show current scope variables |
| `<leader>df` | Show Frames | Show stack frames |

### Debug Session

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>dx` | Stop Debugging | Terminate debug session |
| `<leader>dq` | Close Session | Close session gracefully |
| `<leader>dQ` | Terminate | Force terminate debugger |
| `<leader>dp` | Pause | Pause execution |
| `<leader>dl` | Run Last | Re-run last debug configuration |

### Telescope DAP

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>dC` | Configurations | List available debug configurations |
| `<leader>dB` | Breakpoints | List breakpoints (Telescope) |
| `<leader>dV` | Variables | Show variables (Telescope) |
| `<leader>dF` | Frames | Show stack frames (Telescope) |

---

## 🔍 Debugging Workflow Examples

### Example 1: Debug Regular C# Console App

```bash
# 1. Open project
cd ~/projects/MyConsoleApp
nvim Program.cs

# 2. In Neovim:
# - Set breakpoint on line 10: <leader>bb
# - Start debugging: F5
# - Select: easy-dotnet
# - Watch it build and run!
```

### Example 2: Debug Lambda Function with AWS Integration

```bash
# 1. Navigate to Lambda project
cd /Users/murilo.preccaro/Documents/GitHub/pim-oracle-sync-acl/src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer

# 2. Update credentials if expired
nvim Properties/launchSettings.json
# Update: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN

# 3. Open handler function
nvim Function.cs

# 4. In Neovim:
# - Set breakpoint in Handler method: <leader>bb
# - Start debugging: F5
# - Select: Lambda Test Tool
# - Wait for notification: "Lambda Test Tool started"

# 5. In browser:
# - Open: http://localhost:5050
# - Select function from dropdown
# - Configure test event payload
# - Click "Execute Function"

# 6. Breakpoint hits in Neovim!
# - Inspect variables: <leader>ds
# - Check AWS credentials loaded: look in Scopes panel
# - Step through code: F10, F11
```

### Example 3: Debug Lambda with SQS Event

```bash
# In Lambda Test Tool UI:
# 1. Select "SQS" from event templates
# 2. Modify payload:
{
  "Records": [
    {
      "messageId": "test-message-1",
      "body": "{\"eventType\":\"ProductUpdated\",\"productId\":123}"
    }
  ]
}
# 3. Click "Execute"
# 4. Watch breakpoint hit in Neovim
# 5. Inspect event data in Scopes panel
```

---

## 🐛 Troubleshooting

### Problem: "Debugger failed to start"

**Possible causes:**
1. vsdbg doesn't have execute permissions
2. Wrong path to vsdbg
3. Lambda Tool DLL path incorrect

**Solutions:**
```bash
# Check vsdbg exists and is executable
ls -la ~/.vscode/extensions/ms-dotnettools.csharp-*/. debugger/arm64/vsdbg
chmod +x ~/.vscode/extensions/ms-dotnettools.csharp-*/. debugger/arm64/vsdbg

# Check Lambda Tool DLL path
ls -la ~/.dotnet/tools/.store/amazon.lambda.testtool-8.0/*/amazon.lambda.testtool-8.0/*/tools/net8.0/any/Amazon.Lambda.TestTool.BlazorTester.dll
```

### Problem: Breakpoints don't hit

**Possible causes:**
1. Code not matching compiled DLL (stale build)
2. `justMyCode` setting filtering breakpoint
3. Source path mismatch

**Solutions:**
```bash
# Clean and rebuild
dotnet clean
dotnet build

# In Neovim, restart debug session
# Press <leader>dx then F5
```

### Problem: Environment variables not loaded

**Possible causes:**
1. launchSettings.json doesn't exist
2. JSON syntax error
3. Wrong profile name

**Solutions:**
```bash
# Verify file exists
ls Properties/launchSettings.json

# Validate JSON syntax
cat Properties/launchSettings.json | jq .

# Check profile name matches exactly
cat Properties/launchSettings.json | jq '.profiles | keys'
# Should include: "Lambda Test Tool"
```

### Problem: Port 5050 already in use

**Solution:**
```bash
# Kill existing Lambda Tool
pkill -f "Lambda.TestTool"
lsof -ti:5050 | xargs kill -9
```

### Problem: AWS credentials expired

**Solution:**
```bash
# Get fresh credentials (your method may vary)
aws sso login

# Update launchSettings.json
nvim Properties/launchSettings.json
# Replace: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN
```

### Problem: Easy-dotnet not working

**Solution:**
```bash
# Update easy-dotnet server
dotnet tool update -g EasyDotnet

# Restart Neovim
# Or run in Neovim:
:Dotnet _server update
```

### Problem: Configuration not appearing in picker

**Solution:**
```bash
# Restart Neovim to reload configuration
# Or reload config:
:source $MYVIMRC

# Check for errors:
:checkhealth nvim-dap
:messages
```

---

## 📚 Advanced Topics

### Custom Lambda Test Tool Port

Edit `nvim-dap.lua` line 136:
```lua
args = { '--port', '5555' },  -- Change from 5050
```

Update `launchSettings.json` to match:
```json
"commandLineArgs": "... --port 5555"
```

### Debug Multiple Lambda Functions

Create multiple profiles in `launchSettings.json`:
```json
{
  "profiles": {
    "Lambda Test Tool - Function A": {
      "commandLineArgs": "... --port 5050",
      ...
    },
    "Lambda Test Tool - Function B": {
      "commandLineArgs": "... --port 5051",
      ...
    }
  }
}
```

Then add corresponding configurations to `nvim-dap.lua`.

### Use Different .NET SDK Version

Update Lambda Tool path in `nvim-dap.lua` line 134:
```lua
program = function()
  -- Change net8.0 to net6.0 or net9.0
  return vim.fn.expand '~/.dotnet/tools/.store/amazon.lambda.testtool-6.0/.../tools/net6.0/any/Amazon.Lambda.TestTool.BlazorTester.dll'
end,
```

---

## 🔄 Migration Notes

### Migrated from `.env.lambda` to `launchSettings.json`

**Old workflow:**
- Credentials in `.env.lambda` file
- Custom `<leader>dL` launcher script
- Separate attach workflow
- netcoredbg debugger (unreliable)

**New workflow:**
- Credentials in `launchSettings.json` (standard .NET)
- Standard `F5` debugging
- Single launch+attach workflow
- vsdbg debugger (Microsoft official)

**Why the change?**
1. ✅ Standard .NET format (works in Rider, VSCode, Visual Studio)
2. ✅ More reliable debugger (vsdbg vs netcoredbg)
3. ✅ Simpler workflow (no custom launchers)
4. ✅ No adapter conflicts with easy-dotnet
5. ✅ Team-friendly (launchSettings.json.template for sharing)

**Clean up (optional):**
```bash
# After confirming new workflow works:
rm .env.lambda
rm .env.lambda.template
```

---

## 📖 References

### Related Files
- Configuration: `~/.config/nvim/lua/custom/plugins/nvim-dap.lua`
- Easy-dotnet setup: `~/.config/nvim/lua/custom/plugins/easy-dotnet.lua`
- Testing guide: `~/.config/nvim/TESTING_CHECKLIST.md`
- This guide: `~/.config/nvim/DEBUGGING.md`

### Plugin Documentation
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [easy-dotnet.nvim](https://github.com/GustavEikaas/easy-dotnet.nvim)
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
- [AWS Lambda Test Tool](https://github.com/aws/aws-lambda-dotnet/tree/master/Tools/LambdaTestTool)

### Microsoft Docs
- [launchSettings.json schema](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/environments#launchsettingsjson)
- [vsdbg documentation](https://github.com/microsoft/vscode-cpptools/blob/main/launch.md)

---

## 💡 Tips and Tricks

### Tip 1: Auto-open DAP UI on debug start

Uncomment in `nvim-dap.lua` (around line 128):
```lua
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
```

### Tip 2: Quick breakpoint navigation

Use Telescope breakpoints:
```
<leader>ba  " List all breakpoints
Enter       " Jump to selected breakpoint
```

### Tip 3: Conditional breakpoints for specific data

```lua
-- Set condition: productId == 123
<leader>bc
-- Enter: productId == 123
```

### Tip 4: Watch expressions

In DAP UI watches panel:
1. Click watches section
2. Type variable name or expression
3. Press Enter
4. Value updates as you step

### Tip 5: Quick variable inspection

Hover method:
```
<leader>dh  " While cursor on variable
```

Eval method (for complex expressions):
```
Visual select expression
<leader>dv
```

---

## 🎓 Learning Resources

### Debugging Basics
1. Start with simple console apps
2. Practice F10/F11/F12 stepping
3. Learn to read stack traces
4. Use conditional breakpoints

### Advanced Debugging
1. Async/await debugging
2. Multi-threaded debugging
3. Exception breakpoints
4. Conditional logging

### Lambda-Specific
1. Understanding Lambda events
2. Testing with SQS/SNS events
3. DynamoDB stream events
4. API Gateway events

---

**Last Updated:** 2026-02-12  
**Neovim Version:** 0.11.5  
**Platform:** macOS ARM64
