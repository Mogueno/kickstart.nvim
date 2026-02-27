# Updated Lambda Debugging Guide

## Your Lambda Setup (Matching Rider)

**Lambda Test Tool Path:** 
`~/.dotnet/tools/.store/amazon.lambda.testtool-8.0/0.16.2/amazon.lambda.testtool-8.0/0.16.2/tools/net8.0/any/Amazon.Lambda.TestTool.BlazorTester.dll`

**Working Directory Example:**
`/Users/murilo.preccaro/Documents/GitHub/pim-oracle-sync-acl/src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer`

## Two Ways to Debug Lambda Functions

### Method 1: Quick Start with `<leader>dL` (Recommended)

1. **Open any file in your Lambda function project**
   - Navigate to your function directory or open a file like `Function.cs`

2. **Press `<leader>dL`**
   - If `aws-lambda-tools-defaults.json` is found, it auto-detects the function directory
   - Otherwise, you'll be prompted to enter the function directory path
   - Enter port (5050) or press Enter for default

3. **Set breakpoints** in your Lambda handler code
   - Press `<leader>bb` on the lines you want to debug

4. **Open browser** to http://localhost:5050
   - Select your function
   - Create or select a test event
   - Click "Execute Function"

5. **Your breakpoints will be hit automatically!**
   - The debugger is launched with the test tool, so breakpoints work immediately

### Method 2: Using F5 Debug Menu

1. **Set breakpoints first** - Press `<leader>bb` on your Lambda handler lines

2. **Press `<F5>`** to open debug menu

3. **Select "Lambda Test Tool - Launch"**
   - It will try to auto-detect your Lambda function directory
   - Or prompt you to enter the path

4. **Open browser** to http://localhost:5050
   - Execute your function
   - Breakpoints will be hit

### Method 3: Attach to Running Test Tool

If you already have the test tool running in a terminal:

1. **Set breakpoints** with `<leader>bb`
2. **Press `<F5>`**
3. **Select "Lambda Test Tool - Attach"**
4. **Choose the `Amazon.Lambda.TestTool` process** from the list
5. **Execute function in browser** - breakpoints will hit

## Auto-Detection Feature

The setup automatically looks for `aws-lambda-tools-defaults.json` in your project to find the Lambda function directory. This file is typically in your function's root directory and is created by the AWS Lambda templates.

If you have multiple Lambda functions in one repository:
- Navigate to a file inside the function you want to debug before pressing `<leader>dL`
- Or manually enter the path when prompted

## Example Project Structure

```
pim-oracle-sync-acl/
├── src/
│   └── Functions/
│       └── OracleSyncAcl.Functions.DomainEventsSynchronizer/
│           ├── aws-lambda-tools-defaults.json  ← Auto-detected!
│           ├── Function.cs                     ← Your handler code
│           └── *.csproj
```

## Debugging Tips

1. **Auto-detect works best** when you have `aws-lambda-tools-defaults.json` in your function directory
2. **Always build first**: `<leader>db` before debugging
3. **Check working directory**: The tool will show which directory it's using
4. **Multiple functions**: Navigate to the specific function's directory first

## Quick Reference

- `<leader>dL` - Start Lambda Test Tool with auto-detection
- `<F5>` - Start debugging (choose "Lambda Test Tool - Launch")
- `<leader>bb` - Toggle breakpoint
- `<leader>du` - Toggle debug UI
- `<leader>dx` - Stop debugging
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out
