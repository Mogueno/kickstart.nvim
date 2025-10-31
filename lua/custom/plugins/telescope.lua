return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
    {
      'ryanmsnyder/toggleterm-manager.nvim',
      dependencies = {
        'akinsho/nvim-toggleterm.lua',
        'nvim-telescope/telescope.nvim',
        'nvim-lua/plenary.nvim',
      },
      config = true,
    },
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
    },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git', 'dist', 'build', '%.lock' },

        layout_strategy = 'vertical',
        layout_config = {
          vertical = {
            height = 0.9,
            preview_cutoff = 40,
            prompt_position = 'top',
            width = 0.8,
          },
        },
        path_display = { 'smart' },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        colorscheme = {
          enable_preview = true,
        },
        buffers = {
          show_all_buffers = true,
          sort_lastused = true,
          previewer = false,
          mappings = {
            i = {
              ['<c-d>'] = 'delete_buffer',
            },
          },
        },
        lsp_references = {
          path_display = { 'smart' },
        },
        lsp_definitions = {
          path_display = { 'smart' },
        },
        lsp_implementations = {
          path_display = { 'smart' },
        },
        lsp_type_definitions = {
          path_display = { 'smart' },
        },
        lsp_document_symbols = {
          path_display = { 'smart' },
        },
        lsp_dynamic_workspace_symbols = {
          path_display = { 'smart' },
        },
        live_grep = {
          path_display = { 'smart' },
        },
        grep_string = {
          path_display = { 'smart' },
        },
      },

      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, {
      desc = '[S]earch [H]elp',
    })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, {
      desc = '[S]earch [K]eymaps',
    })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, {
      desc = '[S]earch [F]iles',
    })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, {
      desc = '[S]earch [S]elect Telescope',
    })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, {
      desc = '[S]earch current [W]ord',
    })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, {
      desc = '[S]earch by [G]rep',
    })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, {
      desc = '[S]earch [D]iagnostics',
    })
    vim.keymap.set('n', '<leader>sr', builtin.resume, {
      desc = '[S]earch [R]esume',
    })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, {
      desc = '[S]earch Recent Files ("." for repeat)',
    })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, {
      desc = '[ ] Find existing buffers',
    })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, {
      desc = '[/] Fuzzily search in current buffer',
    })

    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, {
      desc = '[S]earch [/] in Open Files',
    })

    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files {
        cwd = vim.fn.stdpath 'config',
      }
    end, {
      desc = '[S]earch [N]eovim files',
    })
  end,
}