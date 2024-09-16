return {
  -- Hop (Better Navigation)
  {
    'phaazon/hop.nvim',
    lazy = true,
    config = function()
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }
    end,
  },
}
