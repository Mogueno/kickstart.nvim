# Lambda Debugging - Complete Guide

## Understanding the Two Steps

Lambda debugging requires **TWO separate things**:
1. **Running the Lambda Test Tool** - This is the web server that hosts your Lambda function
2. **Attaching the Debugger** - This is what makes breakpoints work

## Method 1: Two-Step Process (Recommended)

### Step 1: Start Lambda Test Tool
Press `<leader>dL`
- Starts the test tool with your environment variables
- Opens at http://localhost:5050
- **NOT debugging yet** - just running the tool

### Step 2: Attach Debugger
1. Press `<F5>` to open debug menu
2. Select **"Lambda Test Tool - Attach"**
3. From the process list, select the `Amazon.Lambda.TestTool.BlazorTester` process

### Step 3: Set Breakpoints & Test
1. Set breakpoints with `<leader>bb` in your Lambda handler
2. Go to http://localhost:5050
3. Execute your function
4. Breakpoints will now hit! 🎯

## Method 2: All-in-One Debug Launch

### Direct Debug Launch
1. Set breakpoints first with `<leader>bb`
2. Press `<F5>`
3. Select **"Lambda Test Tool - Launch"**
4. This starts the tool AND attaches debugger in one step
5. Open http://localhost:5050 and execute your function

**Note**: This method loads environment variables automatically from `.env.lambda`

## Method 3: Quick Debug Shortcut

Press `<leader>dD` (new shortcut!)
- This opens the debug menu directly
- Select "Lambda Test Tool - Launch"
- Starts with debugging enabled

## Why Two Steps?

The Lambda Test Tool is a web application that:
1. Needs to **run** to host your Lambda function
2. Needs the **debugger attached** to pause at breakpoints

Think of it like:
- `<leader>dL` = Running your app normally (no debugging)
- `<F5>` + Attach = Connecting the debugger to your running app

## Complete Workflow Example

```
┌─────────────────────────────────────────────┐
│ Quick Two-Step Method (Recommended)         │
└─────────────────────────────────────────────┘

1. Open Function.cs
2. <leader>bb           Set breakpoint in FunctionHandler
3. <leader>dL           Start Lambda Test Tool (with env vars)
4. <F5>                 Open debug menu
5. Select "Attach"      Choose Amazon.Lambda.TestTool process
6. Open browser         Go to http://localhost:5050
7. Execute function     Your breakpoint hits! 🎯
8. <F10>                Step through code
9. <leader>dx           Stop debugging when done
```

```
┌─────────────────────────────────────────────┐
│ One-Step Method (Simpler, but slower start) │
└─────────────────────────────────────────────┘

1. Open Function.cs
2. <leader>bb           Set breakpoint
3. <F5>                 Open debug menu
4. Select "Launch"      Starts tool + debugger together
5. Wait for startup     (takes a few seconds)
6. Open browser         Go to http://localhost:5050
7. Execute function     Breakpoint hits! 🎯
```

## Troubleshooting

### "Breakpoints not hitting after <leader>dL"
✅ This is expected! You need to attach the debugger:
- Press `<F5>` → Select "Lambda Test Tool - Attach"

### "Can't find process to attach to"
- Make sure the tool is running (you should see it in the terminal)
- Look for `Amazon.Lambda.TestTool.BlazorTester` or `dotnet` in the process list
- If not found, the tool might have crashed - check terminal for errors

### "Environment variables not loading with F5"
- The "Lambda Test Tool - Launch" option loads `.env.lambda` automatically
- The two-step method (`<leader>dL` + Attach) also loads env vars
- Both methods work the same!

## Quick Reference

### Start Tool (No Debugging)
- `<leader>dL` - Start Lambda Test Tool with env vars

### Start Debugging
- `<F5>` → "Launch" - Start tool + debug in one step
- `<F5>` → "Attach" - Attach to already running tool
- `<leader>dD` - Quick shortcut to debug menu

### Debug Controls
- `<leader>bb` - Toggle breakpoint
- `<F5>` - Continue
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out
- `<leader>dx` - Stop debugging
- `<leader>du` - Toggle debug UI

## Pro Tips

1. **Use the two-step method when**:
   - You need to restart your function multiple times
   - You want to inspect the tool's output in the terminal
   - You're iterating quickly (tool stays running, just reattach debugger)

2. **Use the one-step method when**:
   - First time debugging
   - You want everything automatic
   - You don't mind waiting a few seconds for startup

3. **Environment variables**:
   - Both methods load from `.env.lambda` automatically
   - Update the file when your AWS session expires
   - File is gitignored - safe to put real credentials

4. **Multiple functions**:
   - Navigate to the function's directory before pressing `<leader>dL`
   - Or use `<F5>` and specify the directory when prompted
