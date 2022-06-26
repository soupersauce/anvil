local null_ok, null_ls = pcall(require, "null-ls-nvim")
local lspsetup_ok, lsp_setup = pcall(require, 'nvim-lsp-setup')
if not lspsetup_ok then
  return
end
require("nvim-navic").setup {}
require("clangd_extensions")

-- TODO: We may need to do this to modify nvim-lsp-setup functions
-- to use formatting fuctions that aren't deprecated.
-- local lspsetup_utils = require('nvim-lsp-setup.utils')

lsp_setup.setup({
  -- nvim-lsp-installer
  -- https://github.com/williamboman/nvim-lsp-installer#configuration
  installer = {
    automatic_installation = true,
  },
  -- Default mappings
  default_mappings = false,
  gD = 'lua vim.lsp.buf.declaration()',
  gd = 'lua vim.lsp.buf.definition()',
  gt = 'lua vim.lsp.buf.type_definition()',
  gi = 'lua vim.lsp.buf.implementation()',
  gr = 'lua vim.lsp.buf.references()',
  K = 'lua vim.lsp.buf.hover()',
  ['<C-k>'] = 'lua vim.lsp.buf.signature_help()',
  ['<leader>rn'] = 'lua vim.lsp.buf.rename()',
  ['<leader>ca'] = 'lua vim.lsp.buf.code_action()',
  ['<leader>f'] = 'lua vim.lsp.buf.format()',
  ['<leader>e'] = 'lua vim.diagnostic.open_float()',
  ['[d'] = 'lua vim.diagnostic.goto_prev()',
  [']d'] = 'lua vim.diagnostic.goto_next()',
  -- Custom mappings, will overwrite the default mappings for the same key
  -- Example mappings for telescope pickers:
  -- TODO: Integrate fzf
  -- gd = 'lua require"telescope.builtin".lsp_definitions()',
  -- gi = 'lua require"telescope.builtin".lsp_implementations()',
  -- gr = 'lua require"telescope.builtin".lsp_references()',
  mappings = {},
  -- Global on_attach
  on_attach = function(client, bufnr)
    navic.attach(client, bufnr)
  end,
  -- Global capabilities
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  -- Configuration of LSP servers  -- capabilities = vim.lsp.protocol.make_client_capabilities(),
  servers = {
  -- AWK
    awk_ls = {},
  -- Ansible
    ansiblels = {},
  -- Bash
    bashls = {},
  -- C/C++
    clangd = require('nvim-lsp-setup.clangd_extensions').setup({}),
  -- cmake
    cmake = {},
  -- css
    cssls = {},
    diagnosticls = {},
    stylelint_lsp = {},
  -- Docker
    dockerls = {},
  -- Golang
    gopls = {
      settings = {
        golsp = {
          gofumpt = true,
          staticcheck = true,
          useplaceholders = true,
          codelenses = {
            gc_details = true,
          },
        }
      }
    },
  -- HTML
    html = {},
  -- JSON
    jsonls = {},
  -- Latex
    ltex = {},
    texlab = {},
  -- lua
    sumneko_lua = require('lua-dev').setup({
      lspconfig = {
        on_attach = function(client)
          -- Avoid LSP formatting conflicts.
          -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflict
          require('nvim-lsp-setup.utils').disable_formatting(client)
        end,
      }
    }),
  -- Markdown
    marksman = {},
  -- Powershell
    powershell_es = {},
  -- puppet
    puppet = {},
  -- prose
    grammarly = {},
  -- python
    pylsp = {},
    jedi_language_server = {},
  -- Rust
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
    slint_lsp = {},
  -- salt
    salt_ls = {},
  -- SQL
    sqls = {},
  -- TOML
    taplo = {},
  -- terrafrom
    terraformls = {},
    tflint = {},
  -- vimL
    vimls = {},
  -- XML
    lemminx = {},
  -- YAML
    yamlls = {},
  }
})
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function()
  local set_keymap = function(lhs, rhs)
    vim.keymap.set('n', lhs, rhs, { noremap = true })
  end

  -- Add keybindings for LSP integration
  set_keymap('<Leader>j', 'vim.lsp.buf.declaration()')
  set_keymap('<Leader>d', 'vim.lsp.buf.definition()')
  set_keymap('<Leader>h', 'vim.lsp.buf.hover()')
  set_keymap('<Leader>i', 'vim.lsp.buf.implementation()')
  set_keymap('<Leader>k', 'vim.lsp.buf.signature_help()')
  set_keymap('<Leader>td', 'vim.lsp.buf.type_definition()')
  set_keymap('<Leader>r', 'vim.lsp.buf.references()')
  set_keymap('<Leader>s', 'vim.lsp.buf.document_symbol()')
  set_keymap('<Leader>w', 'vim.lsp.buf.workspace_symbol()')
  set_keymap('<Leader>]', 'vim.diagnostic.goto_next()')
  set_keymap('<Leader>[', 'vim.diagnostic.goto_prev()')

end

do
  local method = 'textDocument/publishDiagnostics'
  local default_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
    default_handler(err, method, result, client_id, bufnr, config)
    vim.diagnostic.setqflist({ open = false })
  end
end

-- Customize how diagnostics are displayed
vim.diagnostic.config({
  virtual_text = true,
  signs = { priority = 0 },
  underline = { severity = vim.diagnostic.severity.ERROR },
  update_in_insert = false,
  severity_sort = false,
})


if not null_ok then
  return
end

null_ls.setup({
  sources = {
    -- Code actions
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.code_actions.shellcheck,

    -- Diagnostics/linters
    null_ls.bultins.diagnostics.ansiblelint,
    null_ls.bultins.diagnostics.checkmake,
    null_ls.bultins.diagnostics.codespell,
    null_ls.bultins.diagnostics.cspell,
    null_ls.bultins.diagnostics.curlylint,
    null_ls.bultins.diagnostics.gitlint,
    null_ls.bultins.diagnostics.golangci_lint,
    null_ls.bultins.diagnostics.jsonlint,
    null_ls.bultins.diagnostics.luacheck,
    null_ls.bultins.diagnostics.shellcheck,
    null_ls.bultins.diagnostics.sqlfluff,
    null_ls.bultins.diagnostics.stylelint,
    null_ls.bultins.diagnostics.tidy,
    null_ls.bultins.diagnostics.vale,
    null_ls.bultins.diagnostics.yamllint,
    null_ls.bultins.diagnostics.zsh,

    -- Formatting
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.latexindent,
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.mdformat,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.puppet_lint,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.shellharden,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.sqlfluff,
    null_ls.builtins.formatting.stylelint,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.formatting.tidy,

    on_attach = function(client)
      require('nvim-lsp-setup.utils').format_on_save(client)
    end,
  },
})
require("docs-view").setup {}
require("rust-tools").setup({})
