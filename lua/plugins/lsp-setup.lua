local status_ok, lsp_setup = pcall(require, 'nvim-lsp-setup')
if not status_ok then
  return
end

-- TODO: We may need to do this to modify nvim-lsp-setup functions
-- to use formatting fuctions that aren't deprecated.
-- local lspsetup_utils = require('nvim-lsp-setup.utils')

lsp_setup.setup({
  -- nvim-lsp-installer
  -- https://github.com/williamboman/nvim-lsp-installer#configuration
  installer = {},
  -- Default mappings
  default_mappings = true,
  -- gD = 'lua vim.lsp.buf.declaration()',
  -- gd = 'lua vim.lsp.buf.definition()',
  -- gt = 'lua vim.lsp.buf.type_definition()',
  -- gi = 'lua vim.lsp.buf.implementation()',
  -- gr = 'lua vim.lsp.buf.references()',
  -- K = 'lua vim.lsp.buf.hover()',
  -- ['<C-k>'] = 'lua vim.lsp.buf.signature_help()',
  ['<leader>rn'] = 'lua vim.lsp.buf.rename()',
  ['<leader>ca'] = 'lua vim.lsp.buf.code_action()',
  ['<leader>f'] = 'lua vim.lsp.buf.format()',
  ['<leader>e'] = 'lua vim.diagnostic.open_float()',
  -- ['[d'] = 'lua vim.diagnostic.goto_prev()',
  -- [']d'] = 'lua vim.diagnostic.goto_next()',
  -- Custom mappings, will overwrite the default mappings for the same key
  -- Example mappings for telescope pickers:
  -- gd = 'lua require"telescope.builtin".lsp_definitions()',
  -- gi = 'lua require"telescope.builtin".lsp_implementations()',
  -- gr = 'lua require"telescope.builtin".lsp_references()',
  mappings = {},
  -- Global on_attach
  on_attach = function(client, bufnr)
    require('nvim-lsp-setup.utils').format_on_save(client)
  end,
  -- Global capabilities
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  -- Configuration of LSP servers  -- capabilities = vim.lsp.protocol.make_client_capabilities(),
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
