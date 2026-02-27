return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Configure DAP UI
    dapui.setup {
      icons = { expanded = '', collapsed = '', current_frame = '' },
      mappings = {
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },
      expand_lines = vim.fn.has 'nvim-0.7' == 1,
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 10,
          position = 'bottom',
        },
      },
      controls = {
        enabled = true,
        element = 'repl',
        icons = {
          pause = '',
          play = '',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '',
          terminate = '',
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil,
        max_value_lines = 100,
      },
    }

    -- Configure virtual text
    require('nvim-dap-virtual-text').setup {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
          return ' = ' .. variable.value
        else
          return variable.name .. ' = ' .. variable.value
        end
      end,
      virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
    }

    -- Automatically open/close DAP UI (disabled by default - use <leader>du to toggle)
    -- Uncomment the lines below if you want the UI to auto-open when debugging starts
    -- dap.listeners.after.event_initialized['dapui_config'] = function()
    --   dapui.open()
    -- end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Configure DAP signs with high visibility
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError', linehl = '', numhl = 'DiagnosticError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn', linehl = '', numhl = 'DiagnosticWarn' })
    vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DiagnosticInfo', linehl = '', numhl = 'DiagnosticInfo' })
    vim.fn.sign_define('DapStopped', { text = '→', texthl = 'DiagnosticHint', linehl = 'Visual', numhl = 'DiagnosticHint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '●', texthl = 'Comment', linehl = '', numhl = 'Comment' })

    -- Lambda debugging adapter using vsdbg (Microsoft's official debugger)
    -- This is separate from easy-dotnet's adapter to avoid conflicts
    dap.adapters.lambda_coreclr = {
      type = 'executable',
      command = vim.fn.expand '~/.vscode/extensions/ms-dotnettools.csharp-2.120.3-darwin-arm64/.debugger/arm64/vsdbg',
      args = { '--interpreter=vscode' },
    }

    dap.configurations.cs = {
      -- Lambda Test Tool debugging configuration
      -- Note: Regular C# debugging is handled by easy-dotnet.nvim plugin
      -- This configuration is specifically for AWS Lambda Test Tool
      {
        type = 'lambda_coreclr',
        name = 'Lambda Test Tool',
        request = 'launch',
        program = function()
          return vim.fn.expand '~/.dotnet/tools/.store/amazon.lambda.testtool-8.0/0.16.2/amazon.lambda.testtool-8.0/0.16.2/tools/net8.0/any/Amazon.Lambda.TestTool.BlazorTester.dll'
        end,
        args = { '--port', '5050' },
        cwd = function()
          -- Auto-detect Lambda function directory by finding aws-lambda-tools-defaults.json
          local lambda_config = vim.fn.findfile('aws-lambda-tools-defaults.json', vim.fn.getcwd() .. '/**')
          if lambda_config ~= '' then
            local function_dir = vim.fn.fnamemodify(lambda_config, ':h')
            vim.notify('Found Lambda function at: ' .. function_dir, vim.log.levels.INFO)
            return function_dir
          else
            vim.notify('Could not find aws-lambda-tools-defaults.json', vim.log.levels.WARN)
            return vim.fn.input('Lambda function directory: ', vim.fn.getcwd(), 'dir')
          end
        end,
        stopAtEntry = false,
        console = 'integratedTerminal',
        justMyCode = false,
        requireExactSource = false,
        env = function()
          -- Read environment variables from launchSettings.json
          local lambda_config = vim.fn.findfile('aws-lambda-tools-defaults.json', vim.fn.getcwd() .. '/**')
          if lambda_config == '' then
            vim.notify('Could not find Lambda project. Environment variables not loaded.', vim.log.levels.WARN)
            return {}
          end
          
          local function_dir = vim.fn.fnamemodify(lambda_config, ':h')
          local launch_settings_path = function_dir .. '/Properties/launchSettings.json'
          
          if vim.fn.filereadable(launch_settings_path) == 1 then
            local content = vim.fn.readfile(launch_settings_path)
            local json_str = table.concat(content, '\n')
            local ok, json = pcall(vim.json.decode, json_str)
            
            if ok and json.profiles and json.profiles['Lambda Test Tool'] then
              local env_vars = json.profiles['Lambda Test Tool'].environmentVariables or {}
              local env_count = vim.tbl_count(env_vars)
              if env_count > 0 then
                vim.notify('Loaded ' .. env_count .. ' environment variables from launchSettings.json', vim.log.levels.INFO)
              end
              return env_vars
            else
              vim.notify('Could not parse launchSettings.json or "Lambda Test Tool" profile not found', vim.log.levels.WARN)
            end
          else
            vim.notify('launchSettings.json not found at: ' .. launch_settings_path, vim.log.levels.WARN)
            vim.notify('Create it from the template: launchSettings.json.template', vim.log.levels.INFO)
          end
          
          return {}
        end,
      },

    }

    -- Keymaps for debugging
    vim.keymap.set('n', '<F5>', function()
      dap.continue()
    end, { desc = 'Debug: Start/Continue' })

    vim.keymap.set('n', '<F10>', function()
      dap.step_over()
    end, { desc = 'Debug: Step Over' })

    vim.keymap.set('n', '<F11>', function()
      dap.step_into()
    end, { desc = 'Debug: Step Into' })

    vim.keymap.set('n', '<F12>', function()
      dap.step_out()
    end, { desc = 'Debug: Step Out' })

    vim.keymap.set('n', '<leader>bb', function()
      dap.toggle_breakpoint()
    end, { desc = 'Debug: Toggle Breakpoint' })

    vim.keymap.set('n', '<leader>bc', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Conditional Breakpoint' })

    vim.keymap.set('n', '<leader>bl', function()
      dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
    end, { desc = 'Debug: Log Point' })

    vim.keymap.set('n', '<leader>br', function()
      dap.clear_breakpoints()
    end, { desc = 'Debug: Clear All Breakpoints' })

    vim.keymap.set('n', '<leader>ba', function()
      require('telescope').extensions.dap.list_breakpoints {}
    end, { desc = 'Debug: List Breakpoints' })

    vim.keymap.set('n', '<leader>dc', function()
      dap.continue()
    end, { desc = 'Debug: Continue' })

    vim.keymap.set('n', '<leader>dj', function()
      dap.down()
    end, { desc = 'Debug: Down Stack Frame' })

    vim.keymap.set('n', '<leader>dk', function()
      dap.up()
    end, { desc = 'Debug: Up Stack Frame' })

    vim.keymap.set('n', '<leader>dl', function()
      dap.run_last()
    end, { desc = 'Debug: Run Last' })

    vim.keymap.set('n', '<leader>do', function()
      dap.step_out()
    end, { desc = 'Debug: Step Out' })

    vim.keymap.set('n', '<leader>dO', function()
      dap.step_over()
    end, { desc = 'Debug: Step Over' })

    vim.keymap.set('n', '<leader>dp', function()
      dap.pause()
    end, { desc = 'Debug: Pause' })

    vim.keymap.set('n', '<leader>dq', function()
      dap.close()
      dapui.close()
    end, { desc = 'Debug: Close Session' })

    vim.keymap.set('n', '<leader>dQ', function()
      dap.terminate()
    end, { desc = 'Debug: Terminate' })

    vim.keymap.set('n', '<leader>di', function()
      dap.step_into()
    end, { desc = 'Debug: Step Into' })

    vim.keymap.set('n', '<leader>dh', function()
      require('dap.ui.widgets').hover()
    end, { desc = 'Debug: Hover Variables' })

    vim.keymap.set('n', '<leader>dR', function()
      dap.repl.toggle()
    end, { desc = 'Debug: Toggle REPL' })

    vim.keymap.set('n', '<leader>du', function()
      dapui.toggle()
    end, { desc = 'Debug: Toggle UI' })

    vim.keymap.set('n', '<leader>ds', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.scopes)
    end, { desc = 'Debug: Scopes' })

    vim.keymap.set('n', '<leader>df', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.frames)
    end, { desc = 'Debug: Frames' })

    vim.keymap.set({ 'n', 'v' }, '<leader>dv', function()
      dapui.eval()
    end, { desc = 'Debug: Evaluate Expression' })

    vim.keymap.set('n', '<leader>dx', function()
      dap.terminate()
      dapui.close()
    end, { desc = 'Debug: Stop' })

    -- Telescope DAP integration
    require('telescope').load_extension 'dap'

    vim.keymap.set('n', '<leader>dC', function()
      require('telescope').extensions.dap.configurations {}
    end, { desc = 'Debug: Configurations' })

    vim.keymap.set('n', '<leader>dB', function()
      require('telescope').extensions.dap.list_breakpoints {}
    end, { desc = 'Debug: Breakpoints' })

    vim.keymap.set('n', '<leader>dV', function()
      require('telescope').extensions.dap.variables {}
    end, { desc = 'Debug: Variables' })

    vim.keymap.set('n', '<leader>dF', function()
      require('telescope').extensions.dap.frames {}
    end, { desc = 'Debug: Frames' })

    -- Add which-key mappings for debugging
    local wk = require 'which-key'
    wk.add {
      { '<leader>b', group = '[B]reakpoint' },
      { '<leader>d', group = '[D]ebug' },
    }
  end,
}
