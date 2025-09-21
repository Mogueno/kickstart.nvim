return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      'antosha417/nvim-lsp-file-operations',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = true, -- hide dotfiles by default
          hide_gitignored = true, -- also hide files ignored by .gitignore
          hide_by_name = {
            '.git', -- explicitly hide .git
          },
          never_show = { -- these are never shown, even if you toggle hidden
            '.git',
          },
          always_show = { -- explicitly always show these
            '.env',
          },
        },
        window = {
          position = 'current',
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
    },
    init = function()
      -- Auto open Neo-tree if nvim starts with a directory
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
            vim.cmd 'Neotree show'
          end
        end,
      })

      -- Replace empty buffer with Neo-tree when all buffers are closed
      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          if vim.fn.bufname() == '' and vim.fn.winnr '$' == 1 then
            vim.cmd 'Neotree show'
          end
        end,
      })
    end,
  },

  {
    's1n7ax/nvim-window-picker',
    version = '2.*',
    config = function()
      require('window-picker').setup {
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          bo = {
            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
            buftype = { 'terminal', 'quickfix' },
          },
        },
      }
    end,
  },
}
