# C# Debugging - Testing Checklist

## ✅ Pre-Testing Setup

Before testing, restart Neovim to load the new configuration:
```bash
# Close all Neovim instances and reopen
nvim
```

---

## Test 1: Verify Configuration Load (No Errors)

**Goal:** Ensure Neovim loads without errors

**Steps:**
1. Open Neovim: `nvim`
2. Check for any error messages on startup
3. Run `:checkhealth nvim-dap`

**Expected Result:**
- ✅ No errors on startup
- ✅ nvim-dap health check passes
- ✅ No conflicts reported

**If errors occur:**
- Check the exact error message
- Verify all files were edited correctly
- Run `:Lazy sync` to ensure all plugins are up to date

---

## Test 2: Easy-Dotnet Regular C# Debugging

**Goal:** Verify easy-dotnet handles regular C# project debugging

**Steps:**
1. Navigate to a regular C# project (not Lambda):
   ```bash
   cd /path/to/regular/csharp/project
   nvim SomeFile.cs
   ```
2. Set a breakpoint: `<leader>bb` on any line with code
3. Start debugging: `F5`
4. You should see a picker with available configurations
5. Select the `easy-dotnet` configuration
6. Trigger the code path with your breakpoint

**Expected Result:**
- ✅ Configuration picker shows `easy-dotnet` option
- ✅ Project builds successfully
- ✅ Debugger starts without errors
- ✅ Breakpoint hits when code executes
- ✅ DAP UI shows variables, stack trace, etc.
- ✅ Can step over/into/out with F10/F11/F12

**If test fails:**
- Check if easy-dotnet backend server is running: `dotnet tool list -g | grep EasyDotnet`
- Update if needed: `:Dotnet _server update`
- Check for build errors in the project

---

## Test 3: Lambda Test Tool Configuration Appears

**Goal:** Verify Lambda configuration is available

**Steps:**
1. Navigate to Lambda project:
   ```bash
   cd /Users/murilo.preccaro/Documents/GitHub/pim-oracle-sync-acl/src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer
   nvim Function.cs
   ```
2. Press `F5` to see debug configurations
3. Look for "Lambda Test Tool" in the picker

**Expected Result:**
- ✅ "Lambda Test Tool" configuration appears in picker
- ✅ No error messages when selecting it

**If test fails:**
- Check if `aws-lambda-tools-defaults.json` exists in project root
- Verify nvim-dap.lua has the Lambda configuration (lines 125-188)

---

## Test 4: Lambda Environment Variables Load

**Goal:** Verify launchSettings.json is read correctly

**Steps:**
1. In Lambda project directory, verify launchSettings.json exists:
   ```bash
   cat Properties/launchSettings.json | grep AWS_ACCESS_KEY_ID
   ```
   - Should show your credentials (not placeholders)
2. In Neovim, open `Function.cs`
3. Press `F5` → Select "Lambda Test Tool"
4. Watch for notification messages about environment variables

**Expected Result:**
- ✅ Notification: "Loaded X environment variables from launchSettings.json"
- ✅ X should be 7 (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN, ORACLESETTINGS__PASSWORD, ORACLESETTINGS__USERNAME, AWS_REGION, ASPNETCORE_ENVIRONMENT)
- ✅ No warnings about missing launchSettings.json

**If test fails:**
- Check if `Properties/launchSettings.json` exists
- Verify JSON is valid: `cat Properties/launchSettings.json | jq .`
- Check if "Lambda Test Tool" profile exists in the JSON

---

## Test 5: Lambda Test Tool Launches

**Goal:** Verify Lambda Test Tool starts correctly with debugger attached

**Steps:**
1. In Lambda project, open Handler function:
   ```bash
   nvim Function.cs
   ```
2. Set breakpoint in `Handler` method: `<leader>bb`
3. Press `F5` → Select "Lambda Test Tool"
4. Wait for Lambda Tool to start (watch notifications)
5. Open browser: `http://localhost:5050`
6. In Lambda Test Tool UI:
   - Select function from dropdown
   - Add test payload (or use sample)
   - Click "Execute Function"

**Expected Result:**
- ✅ Lambda Test Tool launches without errors
- ✅ Browser opens Lambda Tool UI at localhost:5050
- ✅ Function appears in dropdown
- ✅ When you execute function, Neovim jumps to breakpoint
- ✅ DAP UI shows variables with AWS credentials populated
- ✅ Can inspect Oracle connection settings in variables

**If test fails:**
- Check vsdbg exists: `ls ~/.vscode/extensions/ms-dotnettools.csharp-*/. debugger/arm64/vsdbg`
- Verify Lambda Tool DLL path is correct: `ls ~/.dotnet/tools/.store/amazon.lambda.testtool-8.0/*/amazon.lambda.testtool-8.0/*/tools/net8.0/any/Amazon.Lambda.TestTool.BlazorTester.dll`
- Check for port conflicts: `lsof -i :5050`

---

## Test 6: Debugging Works (Step Through Code)

**Goal:** Verify full debugging capabilities

**Steps:**
1. While stopped at breakpoint (from Test 5):
2. Press `F10` to step over
3. Press `F11` to step into method calls
4. Press `F12` to step out
5. Hover over variables: `<leader>dh`
6. Check DAP UI scopes panel
7. Add watch expression: Click in watches panel

**Expected Result:**
- ✅ Step over moves to next line
- ✅ Step into enters method calls
- ✅ Step out returns to caller
- ✅ Hover shows variable values
- ✅ Scopes panel shows local variables
- ✅ Environment variables visible (AWS_*, ORACLESETTINGS_*)
- ✅ Can evaluate expressions in REPL

**If test fails:**
- Check if debugger session is active: `:lua print(vim.inspect(require('dap').session()))`
- Try stopping and restarting debug session: `<leader>dx` then `F5`

---

## Test 7: No Adapter Conflicts

**Goal:** Ensure easy-dotnet and Lambda adapters don't conflict

**Steps:**
1. Open any C# file
2. Press `<leader>dC` (Debug: Configurations)
3. Review available configurations

**Expected Result:**
- ✅ See "easy-dotnet" configuration
- ✅ See "Lambda Test Tool" configuration
- ✅ Both can be selected without errors
- ✅ No duplicate or conflicting "coreclr" adapters

**If test fails:**
- Check nvim-dap.lua for duplicate adapter definitions
- Verify easy-dotnet `auto_register_dap = true` in easy-dotnet.lua
- Restart Neovim to clear any cached configurations

---

## Test 8: Verify Old Keymaps Removed

**Goal:** Ensure custom Lambda launcher is gone

**Steps:**
1. In Neovim, press `<leader>dL`

**Expected Result:**
- ✅ Keymap does not exist (no action or error about undefined keymap)
- ✅ Use `F5` → "Lambda Test Tool" instead

**If keymap still exists:**
- Verify nvim-dap.lua has `<leader>dL` keymap removed (should not be in file)
- Restart Neovim

---

## 🎯 Summary Checklist

Mark each test as you complete it:

- [ ] Test 1: Configuration loads without errors
- [ ] Test 2: Easy-dotnet debugging works for regular C#
- [ ] Test 3: Lambda Test Tool config appears in picker
- [ ] Test 4: Environment variables load from launchSettings.json
- [ ] Test 5: Lambda Test Tool launches with debugger
- [ ] Test 6: Full debugging (step through code) works
- [ ] Test 7: No adapter conflicts between easy-dotnet and Lambda
- [ ] Test 8: Old `<leader>dL` keymap removed

---

## 🐛 Common Issues and Fixes

### Issue: "Debugger failed to start"
**Fix:** 
```bash
# Ensure vsdbg has execute permissions
chmod +x ~/.vscode/extensions/ms-dotnettools.csharp-*/. debugger/arm64/vsdbg
```

### Issue: "Could not find Lambda project"
**Fix:**
```bash
# Ensure you're in the right directory
cd /path/to/lambda/function
# Verify aws-lambda-tools-defaults.json exists
ls aws-lambda-tools-defaults.json
```

### Issue: Environment variables not loaded
**Fix:**
```bash
# Check launchSettings.json exists and has correct format
cat Properties/launchSettings.json | jq '.profiles["Lambda Test Tool"].environmentVariables'
```

### Issue: Port 5050 already in use
**Fix:**
```bash
# Kill existing Lambda Tool processes
pkill -f "Lambda.TestTool"
lsof -ti:5050 | xargs kill -9
```

### Issue: Easy-dotnet not working
**Fix:**
```bash
# Update easy-dotnet server
dotnet tool update -g EasyDotnet
# Restart Neovim
```

---

## 📝 Next Steps After Testing

1. ✅ If all tests pass → Mark Phase 4 complete
2. ✅ Document any issues encountered → Report to maintainer
3. ✅ Clean up old files → Remove `.env.lambda` once confirmed working
4. ✅ Update team documentation → Share launchSettings.json.template

---

## 🔄 Rollback Plan (If Tests Fail)

If testing reveals major issues, you can rollback:

```bash
cd /Users/murilo.preccaro/.config/nvim
git diff lua/custom/plugins/nvim-dap.lua  # Review changes
git checkout lua/custom/plugins/nvim-dap.lua  # Restore old version

# Remove new files
rm /Users/murilo.preccaro/Documents/GitHub/pim-oracle-sync-acl/src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer/Properties/launchSettings.json
```

Then report issues so we can fix them before trying again.
