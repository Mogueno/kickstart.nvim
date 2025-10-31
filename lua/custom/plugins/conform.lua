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
        command = 'csharpier',
        args = {
          'format',
          '--write-stdout',
        },
        to_stdin = true,
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