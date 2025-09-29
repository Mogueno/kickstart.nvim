return {
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      require('easy-dotnet').setup {
        test_runner = {
          viewmode = 'float',
          enable_buffer_test_execution = true,
          noBuild = true,
          icons = {
            passed = '',
            skipped = '',
            failed = '',
            success = '',
            reload = '',
            test = '',
            sln = '󰘐',
            project = '󰘐',
            dir = '',
            package = '',
          },
          mappings = {
            run_test_from_buffer = { lhs = '<leader>tr', desc = 'run test from buffer' },
            peek_stack_trace_from_buffer = { lhs = '<leader>tp', desc = 'peek stack trace from buffer' },
            filter_failed_tests = { lhs = '<leader>tf', desc = 'filter failed tests' },
            debug_test = { lhs = '<leader>td', desc = 'debug test' },
            go_to_file = { lhs = 'g', desc = 'go to file' },
            run_all = { lhs = '<leader>tR', desc = 'run all tests' },
            run = { lhs = '<leader>tr', desc = 'run test' },
            peek_stacktrace = { lhs = '<leader>tp', desc = 'peek stacktrace of failed test' },
            expand = { lhs = 'o', desc = 'expand' },
            expand_node = { lhs = 'E', desc = 'expand node' },
            expand_all = { lhs = '-', desc = 'expand all' },
            collapse_all = { lhs = 'W', desc = 'collapse all' },
            close = { lhs = 'q', desc = 'close testrunner' },
            refresh_testrunner = { lhs = '<C-r>', desc = 'refresh testrunner' },
          },
        },
        terminal = function(path, action, args)
          args = args or ''
          local commands = {
            run = function()
              return string.format('dotnet run --project %s %s', path, args)
            end,
            test = function()
              return string.format('dotnet test %s %s', path, args)
            end,
            restore = function()
              return string.format('dotnet restore %s %s', path, args)
            end,
            build = function()
              return string.format('dotnet build %s %s', path, args)
            end,
            watch = function()
              return string.format('dotnet watch --project %s %s', path, args)
            end,
          }
          local command = commands[action]()
          vim.cmd 'vsplit'
          vim.cmd('term ' .. command)
        end,
        csproj_mappings = true,
        fsproj_mappings = true,
        auto_bootstrap_namespace = {
          type = 'block_scoped',
          enabled = true,
        },
        picker = 'telescope',
        background_scanning = true,
        debugger = {
          auto_register_dap = true,
        },
        diagnostics = {
          default_severity = 'error',
          setqflist = false,
        },
      }

      -- Set up keymaps for easy-dotnet
      local dotnet = require 'easy-dotnet'
      vim.keymap.set('n', '<leader>dr', dotnet.run, { desc = 'Dotnet: Run project' })
      vim.keymap.set('n', '<leader>dR', dotnet.run_default, { desc = 'Dotnet: Run default project' })
      vim.keymap.set('n', '<leader>db', dotnet.build, { desc = 'Dotnet: Build project' })
      vim.keymap.set('n', '<leader>dB', dotnet.build_default, { desc = 'Dotnet: Build default project' })
      vim.keymap.set('n', '<leader>dt', dotnet.test, { desc = 'Dotnet: Test project' })
      vim.keymap.set('n', '<leader>dT', dotnet.test_default, { desc = 'Dotnet: Test default project' })
      vim.keymap.set('n', '<leader>dw', dotnet.watch, { desc = 'Dotnet: Watch project' })
      vim.keymap.set('n', '<leader>dW', dotnet.watch_default, { desc = 'Dotnet: Watch default project' })
      vim.keymap.set('n', '<leader>dn', dotnet.new, { desc = 'Dotnet: New template' })
      vim.keymap.set('n', '<leader>ds', dotnet.secrets, { desc = 'Dotnet: User secrets' })
      vim.keymap.set('n', '<leader>dc', dotnet.clean, { desc = 'Dotnet: Clean solution' })
      vim.keymap.set('n', '<leader>dS', dotnet.restore, { desc = 'Dotnet: Restore solution' })
      
      -- Test runner
      vim.keymap.set('n', '<leader>tt', dotnet.testrunner, { desc = 'Dotnet: Toggle test runner' })
      vim.keymap.set('n', '<leader>tT', dotnet.testrunner_refresh, { desc = 'Dotnet: Refresh test runner' })
      
      -- Package management
      vim.keymap.set('n', '<leader>da', dotnet.add_package, { desc = 'Dotnet: Add package' })
      vim.keymap.set('n', '<leader>do', dotnet.outdated, { desc = 'Dotnet: Show outdated packages' })

      -- Add which-key mappings
      local wk = require 'which-key'
      wk.add {
        { '<leader>d', group = '[D]otnet', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]ests', mode = { 'n', 'v' } },
      }
    end,
  },
}