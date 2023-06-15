---@diagnostic disable: unused-local, unused_variable
local M = { -- LSP: integration
	{ 'simrat39/rust-tools.nvim', ft = { 'rust' }, event = 'BufRead Cargo.toml' },
	'neovim/nvim-lspconfig',
	{
		'p00f/clangd_extensions.nvim',
		ft = {
			'c',
			'cpp',
			'objc',
			'objcpp',
		},
	},
	'b0o/schemastore.nvim',
	'ray-x/go.nvim',
	{ -- mason-lspconfig
		'williamboman/mason-lspconfig.nvim',
		dependencies = 'simrat39/rust-tools.nvim',
		config = function()
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
					'lua_ls', -- lua
					'marksman', -- Markdown
					'powershell_es', -- Powershell
					'puppet', -- puppet
					'pylsp', -- python
					'jedi_language_server', -- python
					'rust_analyzer', -- rust
					'slint_lsp', -- rust gui framework
					'salt_ls', -- salt
					'sqlls', -- SQL
					'taplo', -- TOML
					'terraformls', -- terrafrom
					'tflint', -- terrafrom
					'lemminx', -- XML
					'yamlls', -- YAML
				},
			}

			require('plugins.lsp.diagnostics').setup()

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local function on_attach(client, bufnr)
				if client.supports_method('textDocument/documentSymbol') then
					require('nvim-navic').attach(client, bufnr)
				end
				require('plugins.lsp.formatting').setup(client, bufnr)
				require('plugins.lsp.keys').setup(client, bufnr)
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

				['jsonls'] = function(bufnr, client)
					require('lspconfig').jsonls.setup {
						on_new_config = function(new_config)
							new_config.settings.json.schemas = new_config.settings.json.schemas or {}
							vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
						end,
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							json = {
								format = {
									enable = true,
								},
								validate = { enable = true },
							},
						},
					}
				end,

				['rust_analyzer'] = function(bufnr, client)
					require('rust-tools').setup {
						server = {
							capabilities = capabilities,
							on_attach = on_attach,
							-- settings = {
							-- 		cargo = {
							-- 			loadOutDirsFromCheck = true,
							-- 		},
							-- 		procMacro = {
							-- 			enable = true,
							-- 		},
							-- },
						},
					}
				end,

				['lua_ls'] = function(bufnr, client)
					require('lspconfig').lua_ls.setup {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							Lua = {
								format = {
									enable = false,
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

				['clangd'] = function(bufnr, client) -- C/C++
					require('clangd_extensions').setup {}
				end,

				['gopls'] = function(bufnr, client) -- Golang
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

				['ltex'] = function(bufnr, client)
					require('lspconfig').ltex.setup {
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							options.on_attach(client, bufnr)
							require('ltex_extra').setup {
								load_langs = { 'en-US' }, -- table <string> : languages for witch dictionaries will be loaded
								init_check = true, -- boolean : whether to load dictionaries on startup
								path = nil, -- string : path to store dictionaries. Relative path uses current working directory
								log_level = 'none', -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
							}
						end,
						settings = {
							ltex = {},
						},
					}
				end,
			}

			require('plugins.null-ls').setup(options)
			local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
			-- vim.o.code_action_menu_window_border = 'single'
			vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
			vim.lsp.handlers['textDocument/signatureHelp'] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
		end,
	},
	{ -- mason-tool-installer
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		opts = {
			ensure_installed = {
				'blue',
				'beautysh',
				'cbfmt',
				'clang-format',
				'codespell',
				'commitlint',
				'curlylint',
				'debugpy',
				'delve',
				'diagnostic-languageserver',
				'eslint_d',
				'flake8',
				'gitlint',
				'gofumpt',
				'goimports',
				'golangci-lint',
				'gopls',
				'hadolint',
				'markdownlint',
				'mypy',
				'powershell-editor-services',
				'prettierd',
				'proselint',
				'puppet-editor-services',
				'pylint',
				'selene',
				'shellcheck',
				'shellharden',
				'shfmt',
				'sqlfluff',
				'stylelint-lsp',
				'stylua',
				'taplo',
				'terraform-ls',
				'tectonic',
				'texlab',
				'textlint',
				'tflint',
				'vale',
				'write-good',
				'yamllint',
				-- 'debugpy-adapter',
				-- 'ansiblelint',
				-- 'checkmake',
				-- 'chktex',
				-- 'dictionary',
				-- 'latexindent',
				-- 'puppet_lint',
				'reorder-python-imports',
				'rustfmt',
				-- 'tidy',
				-- Debug adapters/DAP
				-- 'go-debug-adapter',
				-- 'node-debug2-adapter',
			},
		},
	},
	{ -- neodev
		'folke/neodev.nvim',
		config = true,
	},
	{ -- FIDGET
		'j-hui/fidget.nvim',
		cond = vim.g.started_by_firenvim == nil,
		branch = 'legacy',
		opts = {
			window = {
				blend = 1,
			},
		},
	},
	{ -- navic
		'SmiteshP/nvim-navic',
		opts = {
			-- highlight = true,
			safe_output = true,
			highlight = true,
			separator = ' » ',
			depth = 8,
			depth_limit_indicator = '',
		},
	},
	{ -- nvim-docs-view
		'amrbashir/nvim-docs-view',
		config = true,
		cmd = 'DocsViewToggle',
	},
	{ -- crates
		'saecki/crates.nvim',
		event = { 'BufRead Cargo.toml' },
		opts = {
			null_ls = {
				enabled = true,
				name = 'crates',
			},
		},
	},
	{ -- mason
		'williamboman/mason.nvim',
		config = true,
	},
	{ -- trouble
		'folke/trouble.nvim',
		config = true,
	},
	'barreiroleo/ltex-extra.nvim',
	{ -- prettier
		'muniftanjim/prettier.nvim',
		opts = {
			bin = 'prettierd',
			filetypes = {
				'css',
				'graphql',
				'html',
				'javascript',
				'javascriptreact',
				'json',
				'less',
				'markdown',
				'scss',
				'typescript',
				'typescriptreact',
				'yaml',
				'org',
			},
		},
	},
	{ -- actions-preview
		'aznhe21/actions-preview.nvim',
		opts = {
			backend = { 'nui', 'telescope' },
		},
	},
}

return M
