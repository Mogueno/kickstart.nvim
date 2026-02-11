return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format {
          async = true,
          lsp_format = 'fallback',
        }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    async = true,
    formatters = {
      csharpier = {
        command = 'dotnet-csharpier',
        args = {},
        stdin = true,
        condition = function(self, ctx)
          return vim.fn.executable('dotnet-csharpier') == 1
        end,
        -- Ensure CSharpier respects .editorconfig by not passing --config-path
        inherit = false,
      },
    },
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      html = { 'prettierd' },
      javascript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      markdown = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      cs = { 'csharpier' },
      ['*'] = { 'trim_whitespace' },
    },
  },
}