local status_ok, lsp_setup = pcall(require, 'nvim-lsp-setup')
if not status_ok then
  return
end

lsp_setup.setup({
  -- on_attach = function (client, bufnr)
  --   require('nvim-lsp-setup.utils').format_on_save(client)
  -- end,
  -- capabilities = vim.lsp.protocol.make_client_capabilities(),
  servers = {
    pylsp = {},
    rust_analyzer = {
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            loadOutDirsFromCheck = true,
          },
          procMacro = {
            enable = true,
          },
        },
      },
    },
    ansiblels = {},
    bashls = {},
    clangd = require('nvim-lsp-setup.clangd_extensions').setup({}),
    cmake = {},
    cssls = {},
    diagnosticls = {},
    dockerls = {},
    gopls = {},
    html = {},
    jsonls = {},
    ltex = {},
    sumneko_lua = require('lua-dev').setup({
      lspconfig = {
        on_attach = function(client, _)
          -- Avoid LSP formatting conflicts.
          -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflict
          require('nvim-lsp-setup.utils').disable_formatting(client)
      end,
      }
    }),
    marksman = {},
    powershell_es = {},
    puppet = {},
    jedi_language_server = {},
    sqls = {},
    taplo = {},
    terraformls = {},
    vimls = {},
    lemminx = {},
    yamlls = {},
  }
})

