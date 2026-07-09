return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason.nvim' },
    opts = { ensure_installed = { 'roslyn-language-server' } },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason.nvim',
      {
        'neovim/nvim-lspconfig',
        config = function()
          vim.lsp.config('lua_ls', {
            settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
          })

          vim.lsp.config('sourcekit', {
            cmd = { 'xcrun', 'sourcekit-lsp' },
          })
          vim.lsp.enable('sourcekit')

          vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client:supports_method('textDocument/inlayHint') then
                vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
              end
              vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action,
                { buffer = args.buf, desc = 'Code Action' })
            end,
          })
        end,
      },
    },
    opts = {
      ensure_installed = { 'lua_ls' },
      automatic_enable = { exclude = { 'omnisharp' } },
    },
  },
  {
    'seblyng/roslyn.nvim',
    ft = 'cs',
    opts = {
      settings = {
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
        },
      },
    },
  },
}
