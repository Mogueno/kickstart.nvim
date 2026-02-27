# Testing DAP Setup

## Test 1: Verify Breakpoint Signs

1. Restart Neovim: `:q` then reopen `nvim`
2. Open any `.cs` file (or create a test one)
3. Press `<leader>bb` on a line
4. You should see a red `●` in the sign column (left side, before line numbers)

If you don't see it:
- Run `:lua print(vim.inspect(require('dap').list_breakpoints()))` to check if breakpoint was set
- Run `:sign list` to see all defined signs
- Run `:checkhealth dap` to verify DAP is loaded

## Test 2: Lambda Test Tool (Better Workflow)

### Step 1: Start Lambda Test Tool
Press `<leader>dL` and enter port (or press Enter for 5050)
- This opens a terminal with the Lambda test tool running
- Open http://localhost:5050 in your browser

### Step 2: Set Breakpoints
In your Lambda function code (e.g., `Function.cs`), press `<leader>bb` on the lines you want to pause at

### Step 3: Attach Debugger
- Press `<F5>`
- Select "Lambda - Attach to running test tool"
- Choose the `dotnet` process from the list

### Step 4: Test Your Function
- In the browser (http://localhost:5050), select your function
- Choose or create a test event
- Click "Execute Function"
- Your breakpoints should be hit!

## Test 3: Regular C# Project

1. Build: `<leader>db`
2. Set breakpoint: `<leader>bb` in your `Main` method or entry point
3. Start debug: `<F5>`
4. Choose "Launch - Auto detect DLL"
5. Code should pause at your breakpoint

## Troubleshooting

### Breakpoints not showing:
```vim
:lua vim.notify(vim.inspect(vim.fn.sign_getdefined('DapBreakpoint')), vim.log.levels.INFO)
```

### Check if DAP loaded:
```vim
:lua print(require('dap').status())
```

### List all breakpoints:
```vim
:lua print(vim.inspect(require('dap').list_breakpoints()))
```

### Manually test breakpoint:
```vim
:lua require('dap').toggle_breakpoint()
:lua print(vim.inspect(require('dap').breakpoints()))
```
