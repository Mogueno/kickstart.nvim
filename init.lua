--
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Load configuration modules
require 'config.options'
require 'config.keymaps'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {
    clear = true,
  }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  {
    import = 'custom.plugins',
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Colorscheme Monokai Pro Spectrum (matching Ghostty theme)
vim.cmd.colorscheme 'monokai-pro'

-- Custom highlight for lines with hints/code actions available
-- Subtle dark blue-gray background tint
-- Configure diagnostics with custom signs (Neovim 0.11+ API)
-- Using Nerd Font icons via unicode escapes
local diagnostic_icons = {
  ERROR = '\u{f057}', -- nf-fa-times_circle
  WARN = '\u{f071}',  -- nf-fa-exclamation_triangle
  INFO = '\u{f05a}',  -- nf-fa-info_circle
  HINT = '\u{f0eb}',  -- nf-fa-lightbulb_o
}

local function setup_diagnostics()
  vim.api.nvim_set_hl(0, 'DiagnosticLineHint', { bg = '#2d3548' })

  -- Force underline highlights with both undercurl and underline fallback
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, underline = true, sp = '#fc618d' })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, underline = true, sp = '#ffd866' })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, underline = true, sp = '#78dce8' })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, underline = true, sp = '#78dce8' })

  vim.diagnostic.config {
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
        [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
        [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
        [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
      },
      linehl = {
        [vim.diagnostic.severity.HINT] = 'DiagnosticLineHint',
      },
    },
    underline = true,
    virtual_text = false,
    update_in_insert = false,
    severity_sort = true,
  }
end

-- Run on startup and whenever colorscheme changes
setup_diagnostics()
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = setup_diagnostics,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
