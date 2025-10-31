return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  opts = function()
    return {
      mode = 'cursor',
      max_lines = 2,
    }
  end,
}