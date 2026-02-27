-- OpenCode floating terminal integration
-- Toggle with <leader>ai - persistent session that hides/shows

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      -- Default settings for all terminals
      shade_terminals = false,
      float_opts = {
        border = 'rounded',
      },
    }

    -- Create a dedicated terminal for OpenCode
    local Terminal = require('toggleterm.terminal').Terminal
    local opencode = Terminal:new {
      cmd = 'opencode',
      dir = 'git_dir', -- Use git root directory
      hidden = true,
      direction = 'float',
      float_opts = {
        border = 'rounded',
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.85)
        end,
      },
      on_open = function(term)
        -- Enter insert mode when opening
        vim.cmd 'startinsert!'
        -- Set local keymaps for the terminal
        vim.keymap.set('t', '<Esc><Esc>', function()
          term:toggle()
        end, { buffer = term.bufnr, desc = 'Hide OpenCode' })
      end,
      on_close = function()
        -- Just hide, don't kill the process
      end,
    }

    -- Toggle function
    local function toggle_opencode()
      opencode:toggle()
    end

    -- Keybinding
    vim.keymap.set('n', '<leader>ai', toggle_opencode, { desc = 'Toggle OpenCode' })

    -- Register with which-key if available
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add {
        { '<leader>a', group = '[A]I', mode = { 'n' } },
      }
    end
  end,
}
