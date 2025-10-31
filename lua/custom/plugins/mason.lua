return {
  'williamboman/mason.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'j-hui/fidget.nvim',
      opts = {},
    },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    require('config.lsp').setup()
  end,
}