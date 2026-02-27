return {
  'stevearc/oil.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'refractalize/oil-git-status.nvim',
  },
  config = function()
    require('oil').setup {
      -- Use oil as the default file explorer
      default_file_explorer = true,
      -- Skip confirmation for simple operations
      skip_confirm_for_simple_edits = true,
      -- Show hidden files by default (toggle with g.)
      view_options = {
        show_hidden = true,
      },
      -- Enable sign column for git status indicators
      win_options = {
        signcolumn = 'yes:2',
      },
      -- Keymaps within oil buffer
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-v>'] = 'actions.select_vsplit',
        ['<C-s>'] = 'actions.select_split',
        ['<C-t>'] = 'actions.select_tab',
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-r>'] = 'actions.refresh',
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = 'actions.tcd',
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
        -- Close oil with backslash (same as your neo-tree toggle)
        ['\\'] = 'actions.close',
      },
    }

    -- Setup git status indicators with Nerd Font symbols
    require('oil-git-status').setup {
      show_ignored = false, -- don't clutter with ignored files
      symbols = {
        index = {
          ['!'] = '󰈅',  -- ignored (nf-md-file_hidden)
          ['?'] = '',  -- untracked (nf-fa-question_circle)
          ['A'] = '󰐕',  -- added (nf-md-plus_thick)
          ['C'] = '󰆏',  -- copied (nf-md-content_copy)
          ['D'] = '󰍴',  -- deleted (nf-md-minus_thick)
          ['M'] = '󰏫',  -- modified (nf-md-pencil)
          ['R'] = '󰑕',  -- renamed (nf-md-rename_box)
          ['T'] = '󰁪',  -- type changed (nf-md-file_swap)
          ['U'] = '󰘬',  -- unmerged (nf-md-source_merge)
          [' '] = ' ',
        },
        working_tree = {
          ['!'] = '󰈅',  -- ignored
          ['?'] = '',  -- untracked
          ['A'] = '󰐕',  -- added
          ['C'] = '󰆏',  -- copied
          ['D'] = '󰍴',  -- deleted
          ['M'] = '󰏫',  -- modified
          ['R'] = '󰑕',  -- renamed
          ['T'] = '󰁪',  -- type changed
          ['U'] = '󰘬',  -- unmerged
          [' '] = ' ',
        },
      },
    }

    -- Git status highlight colors (Monokai Pro Spectrum inspired)
    -- Index (staged) - left column, typically green tones
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexUntracked', { fg = '#a9dc76' }) -- green
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexAdded', { fg = '#a9dc76' })     -- green
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexCopied', { fg = '#a9dc76' })    -- green
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexDeleted', { fg = '#ff6188' })   -- red/pink
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexModified', { fg = '#78dce8' })  -- cyan
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexRenamed', { fg = '#ab9df2' })   -- purple
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexTypeChanged', { fg = '#ffd866' }) -- yellow
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexUnmerged', { fg = '#fc9867' })  -- orange
    vim.api.nvim_set_hl(0, 'OilGitStatusIndexIgnored', { fg = '#5b595c' })   -- gray

    -- Working tree (unstaged) - right column, same colors
    vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeUntracked', { fg = '#a9dc76' })
    vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeAdded', { fg = '#a9dc76' })
    vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeCopied', { fg = '#a9dc76' })
    vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeDeleted', { fg = '#ff6188' })
    vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeModified', { fg = '#fc9867' }) -- orange for unstaged
    vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeRenamed', { fg = '#ab9df2' })
    vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeTypeChanged', { fg = '#ffd866' })
    vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeUnmerged', { fg = '#fc9867' })
    vim.api.nvim_set_hl(0, 'OilGitStatusWorkingTreeIgnored', { fg = '#5b595c' })

    -- Keybinding: \ to open oil in parent directory of current file
    vim.keymap.set('n', '\\', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
  init = function()
    -- Auto open oil if nvim starts with a directory
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
          require('oil').open()
        end
      end,
    })
  end,
}
