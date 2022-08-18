local vim = vim
local u = require('configuration.utils')
local null_ok, null_ls = pcall(require, 'null-ls')
local lspsetup_ok, lsp_setup = pcall(require, 'nvim-lsp-setup')
local navic_ok, navic = pcall(require, 'nvim-navic')
local lspsig_ok, lspsignature = pcall(require, 'lsp_signature')
local trouble_ok, trouble = pcall(require, 'trouble')
local crates_ok, crates = pcall(require, 'crates')
local rust_ok, rust = pcall(require, 'rust-tools')
local textra_ok, textra = pcall(require, 'ltex_extra')
require('clangd_extensions')

local eslint_disabled_buffers = {}

if not lspsetup_ok then
	return
end

-- TODO: We may need to do this to modify nvim-lsp-setup functions
-- to use formatting functions that aren't deprecated.
-- local lspsetup_utils = require('nvim-lsp-setup.utils')

if navic_ok then
	navic.setup {}
end

if lspsig_ok then
	lspsignature.setup()
end

if trouble_ok then
	trouble.setup()
else
	print('trouble with trouble')
end

local function show_documentation(bufnr)
	local filetype = vim.bo.filetype
	if vim.tbl_contains({ 'vim', 'help' }, filetype) then
		vim.cmd('h ' .. vim.fn.expand('<cword>'))
	elseif vim.tbl_contains({ 'man' }, filetype) then
		vim.cmd('Man ' .. vim.fn.expand('<cword>'))
	elseif vim.fn.expand('%:t') == 'Cargo.toml' then
		require('crates').show_popup()
	elseif vim.tbl_contains({ 'rust' }, filetype) then
		rust.hover_actions.hover_actions { buffer = bufnr }
	else
		vim.lsp.buf.hover()
	end
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	if not (client and client.name == 'eslint_d') then
		goto done
	end

	for _, diagnostic in ipairs(result.diagnostics) do
		if diagnostic.message:find('The file does not match your project config') then
			local bufnr = vim.uri_to_bufnr(result.uri)
			eslint_disabled_buffers[bufnr] = true
		end
	end

	::done::
	return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, config)
end

local mappings = {

	-- Add keybindings for LSP integration
	gD = 'lua vim.lsp.buf.declaration()',
	-- gd = 'lua vim.lsp.buf.definition()',
	K = 'lua vim.lsp.buf.hover()',
	-- gi = 'lua vim.lsp.buf.implementation()',
	['<Leader>k'] = 'lua show_documentation(bufnr)',
	gt = 'lua vim.lsp.buf.type_definition()',
	-- gr = 'lua vim.lsp.buf.references()',
	['<Leader>s'] = 'lua vim.lsp.buf.document_symbol()',
	['<Leader>w'] = 'lua vim.lsp.buf.workspace_symbol()',
	[']d'] = 'lua vim.diagnostic.goto_next()',
	['[d'] = 'lua vim.diagnostic.goto_prev()',
	['<leader>rn'] = 'lua vim.lsp.buf.rename()',
	-- ['<leader>ca'] = 'lua vim.lsp.buf.code_action()',
	['<leader>f'] = 'lua vim.lsp.buf.format()',
	['<leader>e'] = 'lua vim.diagnostic.open_float()',
	-- Custom mappings, will overwrite the default mappings for the same key
	-- Example mappings for telescope pickers:
	gd = 'lua require("telescope.builtin").lsp_definitions()',
	gi = 'lua require("telescope.builtin").lsp_implementations()',
	gr = 'lua require("telescope.builtin").lsp_references()',

	['<leader>ca'] = 'CodeActionMenu',
}

local lsp_formatting = function(bufnr)
	local clients = vim.lsp.get_active_clients { bufnr = bufnr }
	vim.lsp.buf.format {
		bufnr = bufnr,
		filter = function(client)
			if client.name == 'eslint' then
				return not eslint_disabled_buffers[bufnr]
			end

			if client.name == 'null-ls' then
				return not u.table.some(clients, function(_, other_client)
					return other_client.name == 'eslint' and not eslint_disabled_buffers[bufnr]
				end)
			end
		end,
	}
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

lsp_setup.setup {
	installer = {
		automatic_installation = true,
	},
	-- Default mappings
	default_mappings = false,
	mappings = mappings,
	-- Global on_attach
	on_attach = function(client, bufnr)
		if client.supports_method('textDocument/formatting') then
			u.buf_command(bufnr, 'LspFormatting', function()
				lsp_formatting(bufnr)
			end)
			vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = augroup,
				buffer = bufnr,
				command = 'LspFormatting',
			})
		end
	end,
	-- Global capabilities
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	-- Configuration of LSP servers  -- capabilities = vim.lsp.protocol.make_client_capabilities(),
	servers = {
		-- AWK
		awk_ls = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- Ansible
		ansiblels = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- Bash
		bashls = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- C/C++
		clangd = {
			require('nvim-lsp-setup.clangd_extensions').setup {},
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- cmake
		cmake = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- css
		cssls = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		diagnosticls = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		stylelint_lsp = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- Docker
		dockerls = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
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
				},
			},
			on_attach = function(client, bufnr)
				navic.attach(client, bufnr)
			end,
			capabilities = capabilities,
		},
		-- HTML
		html = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- JSON
		jsonls = {
			settings = {
				json = {
					-- schemas = require('schemastore').json.schemas(),
				},
			},
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- Latex
		ltex = {
			lspconfig = {
				on_attach = function(client, bufnr)
					textra.setup {}
				end,
				capabilities = capabilities,
			},
		},
		texlab = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- lua
		sumneko_lua = require('lua-dev').setup {
			lspconfig = {
				settings = {
					Lua = {
						format = {
							enable = true,
						},
					},
				},
				on_attach = function(client, bufnr)
					-- Avoid LSP formatting conflicts.
					-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflict
					-- require('nvim-lsp-setup.utils').disable_formatting(client)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
				telemetry = { enable = false },
			},
		},
		-- Markdown
		marksman = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- Powershell
		powershell_es = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- puppet
		puppet = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- prose
		grammarly = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- python
		pylsp = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		jedi_language_server = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- Rust
		rust_analyzer = require('lsp-setup.rust-tools').setup {
			server = {
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
			on_attach = function(client, bufnr)
				navic.attach(client, bufnr)
			end,
			capabilities = capabilities,
		},
		slint_lsp = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- salt
		salt_ls = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- SQL
		sqls = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- TOML
		taplo = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- terrafrom
		terraformls = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		tflint = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- XML
		lemminx = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
		-- YAML
		yamlls = {
			lspconfig = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				capabilities = capabilities,
			},
		},
	},
}

do
	local method = 'textDocument/publishDiagnostics'
	local default_handler = vim.lsp.handlers[method]
	vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
		default_handler(err, method, result, client_id, bufnr, config)
		vim.diagnostic.setqflist { open = false }
	end
end

-- Customize how diagnostics are displayed
vim.diagnostic.config {
	virtual_text = true,
	signs = { priority = 0 },
	underline = { severity = vim.diagnostic.severity.ERROR },
	update_in_insert = false,
	severity_sort = false,
}
if crates_ok then
	crates.setup {
		null_ls = {
			enabled = true,
			name = 'crates',
		},
	}
end

if not null_ok then
	print('Null not ok')
	return
end

local with_root_file = function(...)
	local files = { ... }
	return function(utils)
		return utils.root_has_file(files)
	end
end

local diagnostics_code_template = '#{m} [#{c}]'

local null_b = null_ls.builtins

local null_sources = {
	-- Code actions
	-- null_b.code_actions.refactoring,
	null_b.code_actions.shellcheck,
	null_b.code_actions.eslint_d,
	null_b.code_actions.proselint.with {
		extra_filetypes = { 'org', 'text' },
	},

	-- Diagnostics/linters
	null_b.diagnostics.eslint_d,
	null_b.diagnostics.chktex,
	null_b.diagnostics.ansiblelint,
	null_b.diagnostics.checkmake,
	null_b.diagnostics.codespell,
	null_b.diagnostics.curlylint,
	null_b.diagnostics.gitlint,
	null_b.diagnostics.golangci_lint,
	null_b.diagnostics.luacheck,
	null_b.diagnostics.pylint,
	null_b.diagnostics.flake8,
	null_b.diagnostics.mypy,
	null_b.diagnostics.markdownlint,
	null_b.diagnostics.proselint.with {
		extra_filetypes = { 'tex', 'org' },
	},
	null_b.diagnostics.write_good.with {
		extra_filetypes = { 'tex', 'org' },
	},
	null_b.diagnostics.shellcheck.with {
		diagnostics_format = diagnostics_code_template,
	},
	null_b.diagnostics.sqlfluff.with {
		extra_args = { '--dialect', 'postgres' },
	},
	null_b.diagnostics.stylelint,
	null_b.diagnostics.tidy,
	null_b.diagnostics.vale.with {
		extra_filetypes = { 'org', 'text' },
		extra_args = { '--config', vim.fn.expand('~/.vale.ini') },
	},
	null_b.diagnostics.yamllint,
	null_b.diagnostics.zsh,

	-- Formatting
	null_b.formatting.blue,
	null_b.formatting.clang_format,
	null_b.formatting.eslint_d,
	null_b.formatting.gofumpt,
	null_b.formatting.goimports,
	null_b.formatting.reorder_python_imports,
	null_b.formatting.latexindent,
	null_b.formatting.stylua.with {
		extra_args = { '--config-path', vim.fn.expand('~/.config/stylua.toml') },
	},
	null_b.formatting.prettier,
	null_b.formatting.puppet_lint,
	null_b.formatting.rustfmt.with {
		extra_args = function(params)
			local Path = require('plenary.path')
			local cargo_toml = Path:new(params.root .. '/' .. 'Cargo.toml')

			if cargo_toml:exists() and cargo_toml:is_file() then
				for _, line in ipairs(cargo_toml:readlines()) do
					local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
					if edition then
						return { '--edition=' .. edition }
					end
				end
			end
			-- default edition when we don't find `Cargo.toml` or the `edition` in it.
			return { '--edition=2021' }
		end,
	},
	null_b.formatting.shellharden,
	null_b.formatting.shfmt,
	null_b.formatting.sqlfluff,
	null_b.formatting.taplo,
	null_b.formatting.terrafmt,
	null_b.formatting.terraform_fmt,
	null_b.formatting.tidy,
	null_b.formatting.beautysh,

	null_b.hover.dictionary,
}

null_ls.setup {
	-- debug = true,
	sources = null_sources,
}

require('mason-tool-installer').setup {
	ensure_installed = {
		'blue',
		'clang-format',
		'codespell',
		'curlylint',
		'debugpy',
		'delve',
		'diagnostic-languageserver',
		'eslint_d',
		'flake8',
		'gitlint',
		'go-debug-adapter',
		'gofumpt',
		'goimports',
		'golangci-lint',
		'gopls',
		'luacheck',
		'markdownlint',
		'mypy',
		'node-debug2-adapter',
		'powershell-editor-services',
		'prettier',
		'proselint',
		'puppet-editor-services',
		'pylint',
		'shellcheck',
		'shellharden',
		'shfmt',
		'sqlfluff',
		'stylelint-lsp',
		'stylua',
		'taplo',
		'terraform-ls',
		'textlint',
		'tflint',
		'vale',
		'write-good',
		'yamllint',
		-- 'ansiblelint',
		-- 'beautysh',
		-- 'checkmake',
		-- 'chktex',
		-- 'dictionary',
		-- 'latexindent',
		-- 'puppet_lint',
		-- 'reorder_python_imports',
		-- 'rustfmt',
		-- 'tidy',
	},
}
require('docs-view').setup {}

local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
