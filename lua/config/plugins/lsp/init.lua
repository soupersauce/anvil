local M = { -- LSP: integration
	'williamboman/mason-lspconfig.nvim',
	dependencies = {
		'williamboman/mason.nvim',
		'neovim/nvim-lspconfig',
		'folke/neodev.nvim',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/nvim-cmp',
	},
}

function M.config()
  local vim = vim
	-- local lspconfig = require('nvim-lspconfig')

	require('mason-lspconfig').setup {
		ensure_installed = {
			'awk_ls', -- AWK
			'ansiblels', -- Ansible
			'bashls', -- Bash
			'cmake', -- cmake
			'cssls', -- css
			'diagnosticls',
			'stylelint_lsp',
			'dockerls', -- Docker
			'gopls', -- golang
			'html', -- HTML
			'ltex', -- Latex
			'sumneko_lua', -- lua
			'marksman', -- Markdown
			'powershell_es', -- Powershell
			'puppet', -- puppet
			'pylsp', -- python
			'jedi_language_server', -- python
			'rust_analyzer', -- rust
			'slint_lsp', -- rust gui framework
			'salt_ls', -- salt
			'sqls', -- SQL
			'taplo', -- TOML
			'terraformls', -- terrafrom
			'tflint', -- terrafrom
			'lemminx', -- XML
			'yamlls', -- YAML
		},
	}

  require("config.plugins.lsp.diagnostics").setup()

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').default_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	local function on_attach(client, bufnr)
		if client.supports_method('textDocument/documentSymbol') then
			require('nvim-navic').attach(client, bufnr)
		end
		require('config.plugins.lsp.formatting').setup(client, bufnr)
		require('config.plugins.lsp.keys').setup(client, bufnr)
	end

          local options = {
            on_attach = on_attach,
            capabilities = capabilities,
            flags = {
              debounce_text_changes = 150,
            },
          }

	require('mason-lspconfig').setup_handlers {

		function(server_name)
			require('lspconfig')[server_name].setup(options)
			--   on_attach = on_attach,
			--   capabilities = capabilities,
			--   -- flags = {
			--   --   debounce_text_changes = 150,
			--   -- },
			-- }
		end,

		['rust_analyzer'] = function()
			require('rust-tools').setup {
				-- server = {
				-- 	settings = {
				-- 		['rust-analyzer'] = {
				-- 			cargo = {
				-- 				loadOutDirsFromCheck = true,
				-- 			},
				-- 			procMacro = {
				-- 				enable = true,
				-- 			},
				-- 		},
				-- 	},
				-- },
			}
		end,

		['sumneko_lua'] = function()
		  require('lspconfig').sumneko_lua.setup {
		  capabilities = capabilities,
		  on_attach = on_attach,
		  settings = {
		    Lua = {
		      format = {

		        enable = true,
		      },
		      completion = {
		        callSnippet = 'Replace',
		      },
		      diagnostics = {
		        globals = { 'vim' },
		      },
		    },
		    telemetry = { enable = false },
		  },
		}
		end,

		['clangd'] = function() -- C/C++
			require('clangd_extensions').setup {}
		end,

		['gopls'] = function() -- Golang
			require('go').setup {
				lsp_cfg = {
					flags = {
						debounce_text_changes = 150,
					},
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						experimentalPostfixCompletions = true,
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
					},
					-- init_options = {
					-- 	usePlaceholders = true,
					-- },
				},
				lsp_gofumpt = true,
				trouble = true,
				comment_useplaceholders = true,
			}
		end,

		['ltex'] = function()
			require('lspconfig').ltex.setup {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
          if client.supports_method('textDocument/documentSymbol') then
            require('nvim-navic').attach(client, bufnr)
          end
          require('config.plugins.lsp.formatting').setup(client, bufnr)
          require('config.plugins.lsp.keys').setup(client, bufnr)
          require("ltex_extra").setup {
              load_langs = { "en-US" }, -- table <string> : languages for witch dictionaries will be loaded
              init_check = true, -- boolean : whether to load dictionaries on startup
              path = nil, -- string : path to store dictionaries. Relative path uses current working directory
              log_level = "none", -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
          }
        end,
        settings = {
          ltex = {},
        },
      }
    end,
	}

	require('config.plugins.null-ls').setup(options)
	local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
	vim.o.code_action_menu_window_border = 'single'
	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
	vim.lsp.handlers['textDocument/signatureHelp'] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
end

return M
