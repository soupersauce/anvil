local vim = vim
local u = require('configuration.utils')
local null_ok, null_ls = pcall(require, 'null-ls')
local navic_ok, navic = pcall(require, 'nvim-navic')
local trouble_ok, trouble = pcall(require, 'trouble')
local crates_ok, crates = pcall(require, 'crates')
local dtextobjects_ok, dtextobjects = pcall(require, 'textobj-diagnostic')
local prettier_ok, prettier = pcall(require, 'prettier')
local neodev_ok, neodev = pcall(require, 'neodev')
local mason_ok, mason = pcall(require, 'mason')
local masonlspc_ok, masonlspc = pcall(require, 'mason-lspconfig')
local lspcfg_ok, lspconfig = pcall(require, 'lspconfig')
local actionpreview_ok, capreview = pcall(require, 'actions-preview')

local eslint_disabled_buffers = {}

if not lspcfg_ok then
	return
end

if navic_ok then
	navic.setup {
		highlight = true,
		safe_output = true,
	}
end

if actionpreview_ok then
	capreview.setup()
end

if trouble_ok then
	trouble.setup()
end

if neodev_ok then
	neodev.setup {}
end

vim.keymap.set('n', 'K', function(bufnr)
	local winid = require('ufo').peekFoldedLinesUnderCursor()
	if not winid then
		local filetype = vim.bo.filetype
		if vim.tbl_contains({ 'vim', 'help' }, filetype) then
			vim.cmd('h ' .. vim.fn.expand('<cword>'))
		elseif vim.tbl_contains({ 'man' }, filetype) then
			vim.cmd('Man ' .. vim.fn.expand('<cword>'))
		elseif vim.fn.expand('%:t') == 'Cargo.toml' then
			require('crates').show_popup()
		elseif vim.tbl_contains({ 'rust' }, filetype) then
			require('rust-tools').hover_actions.hover_actions { buffer = bufnr }
		else
			vim.lsp.buf.hover()
		end
	end
end, { noremap = true, desc = 'Show Documentation' })

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

local def_mappings = function(bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	-- Add keybindings for LSP integration
	vim.keymap.set('n', 'gD', function()
		vim.lsp.buf.declaration()
	end, bufopts)
	vim.keymap.set('n', 'gt', function()
		vim.lsp.buf.type_definition()
	end, bufopts)
	-- gr = 'lua vim.lsp.buf.references()',
	vim.keymap.set('n', '<Leader>s', function()
		vim.lsp.buf.document_symbol()
	end, bufopts)
	vim.keymap.set('n', '<Leader>w', function()
		vim.lsp.buf.workspace_symbol()
	end, bufopts)
	--  if not dtextobjects_ok then
	-- ']d' = 'lua vim.diagnostic.goto_next()',
	-- '[d' = 'lua vim.diagnostic.goto_prev()',
	--  end,
	vim.keymap.set('n', '<leader>rn', function()
		vim.lsp.buf.rename()
	end, bufopts)
	-- ['<leader>ca'] = 'lua vim.lsp.buf.code_action()',
	vim.keymap.set('n', '<leader>f', function()
		vim.lsp.buf.format()
	end, bufopts)
	vim.keymap.set('n', '<leader>e', function()
		vim.diagnostic.open_float()
	end, bufopts)
	-- Custom mappings, will overwrite the default mappings for the same key
	-- Example mappings for telescope pickers:
	vim.keymap.set('n', 'gd', function()
		require('telescope.builtin').lsp_definitions()
	end, bufopts)
	vim.keymap.set('n', '<leader>i', function()
		require('telescope.builtin').lsp_implementations()
	end, bufopts)
	vim.keymap.set('n', 'gr', function()
		require('telescope.builtin').lsp_references()
	end, bufopts)

	vim.keymap.set({ 'v', 'n' }, '<leader>ca', capreview.code_actions, bufopts)
end

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

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

mason.setup()

masonlspc.setup {
	ensure_installed = {
		'awk_ls', -- AWK
		'ansiblels', -- Ansible
		'bashls', -- Bash
		'cmake', -- cmake
		'cssls', -- css
		'diagnosticls',
		'stylelint_lsp',
		'dockerls', -- Docker
		'gopls',
		'html', -- HTML
		'ltex', -- Latex
		'sumneko_lua',
		'marksman', -- Markdown
		'powershell_es', -- Powershell
		'puppet', -- puppet
		'pylsp', -- python
		'jedi_language_server', -- python
		'rust_analyzer',
		'slint_lsp',
		'salt_ls', -- salt
		'sqls', -- SQL
		'taplo', -- TOML
		'terraformls', -- terrafrom
		'tflint', -- terrafrom
		'lemminx', -- XML
		'yamlls', -- YAML
	},
}

masonlspc.setup_handlers {

	function(server_name)
		require('lspconfig')[server_name].setup {
			on_attach = function(client, bufnr)
				def_mappings(bufnr)
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
				if
					client.supports_method('textDocument/documentSymbol')
					and not client.supports_method('textDocument/SymbolInformation')
				then
					navic.attach(client, bufnr)
				end
			end,
			-- Global capabilities
			capabilities = vim.lsp.protocol.make_client_capabilities(),
		}
	end,

	['rust_analyzer'] = function()
		require('rust-tools').setup {
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
		}
	end,

	['sumneko_lua'] = function()
		lspconfig.sumneko_lua.setup {
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
			},
			on_attach = function(client, bufnr)
				-- Avoid LSP formatting conflicts.
				-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflict
				-- require('nvim-lsp-setup.utils').disable_formatting(client)
			end,
			capabilities = capabilities,
			telemetry = { enable = false },
		}
	end,

	['clangd'] = function() -- C/C++
		require('clangd_extensions').setup {}
	end,

	['gopls'] = function() -- Golang
		require('go').setup {
			lsp_cfg = {
				capabilities = capabilities,
			},
			lsp_gofumpt = true,
			trouble = true,
			comment_useplaceholders = true,
		}
	end,

	['ltex'] = function()
		lspconfig.ltex.setup {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				require('ltex_extra').setup {
					load_langs = { 'en-US' },
					init_check = true,
					path = vim.fn.expand('~/.config/nvim/dictionaries'),
					log_level = 'warn',
				}
			end,
			settings = {
				ltex = {},
			},
		}
	end,

	['texlab'] = function()
		lspconfig.texlab.setup {
			filetypes = { 'tex', 'bib', 'plaintex', 'org', 'markdown' },
		}
	end,

	['jsonls'] = function() -- JSON
		lspconfig.jsonls.setup {
			settings = {
				json = {
					schemas = require('schemastore').json.schemas(),
					validate = { enable = true },
				},
			},
		}
	end,
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

local cactions = null_ls.builtins.code_actions
local diag = null_ls.builtins.diagnostics
local format = null_ls.builtins.formatting
local hover = null_ls.builtins.hover

local null_sources = {
	-- Code actions
	-- null_b.code_actions.refactoring,
	cactions.shellcheck,
	cactions.eslint_d,
	cactions.proselint.with {
		extra_filetypes = { 'org', 'text' },
	},

	-- diag/linters
	diag.eslint_d,
	diag.chktex,
	diag.ansiblelint,
	diag.checkmake,
	diag.codespell,
	diag.commitlint,
	diag.curlylint,
	diag.gitlint,
	diag.golangci_lint,
	diag.hadolint,
	diag.luacheck,
	diag.pylint,
	diag.flake8,
	diag.mypy,
	diag.markdownlint,
	diag.proselint.with {
		extra_filetypes = { 'tex', 'org' },
		extra_args = { '--config', vim.fn.expand('~/.config/proselint/config.json') },
		cwd = function()
			return vim.fn.expand('~')
		end,
	},
	diag.selene,
	diag.shellcheck.with {
		diag_format = diagnostics_code_template,
	},
	diag.sqlfluff.with {
		extra_args = { '--dialect', 'postgres' },
	},
	diag.stylelint,
	diag.tidy,
	diag.vale.with {
		extra_filetypes = { 'org', 'text', 'txt' },
	},
	diag.write_good.with {
		extra_filetypes = { 'tex', 'org' },
	},
	diag.yamllint,
	diag.zsh,

	-- format
	format.blue,
	format.cbfmt,
	format.clang_format,
	format.codespell,
	format.eslint_d,
	format.fnlfmt,
	format.gofumpt,
	format.goimports,
	format.jq,
	format.latexindent,
	format.markdownlint,
	format.mdformat,
	format.stylua.with {
		extra_args = { '--config-path', vim.fn.expand('~/.config/stylua.toml') },
	},
	format.prettierd,
	format.reorder_python_imports,
	format.rustfmt.with {
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
	format.shellharden,
	format.shfmt,
	format.sqlfluff,
	format.taplo,
	format.terrafmt,
	format.terraform_fmt,
	format.tidy,
	format.beautysh,

	hover.dictionary,
}

null_ls.setup {
	-- debug = true,
	sources = null_sources,
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			vim.keymap.set({ 'n' }, '<leader>f', function()
				vim.lsp.buf.format()
			end, { silent = true, noremap = true, desc = 'format from null' })
			vim.api.nvim_create_autocmd('BufWritePre', {
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end

		if client.server_capabilities.documentRangeFormattingProvider then
			vim.keymap.set({ 'n' }, '<leader>f', function()
				vim.lsp.buf.format()
			end, { silent = true, noremap = true, desc = 'format from null' })
		end
	end,
}

require('mason-tool-installer').setup {
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
		'go-debug-adapter',
		'gofumpt',
		'goimports',
		'golangci-lint',
		'gopls',
		'hadolint',
		'luacheck',
		'markdownlint',
		'mypy',
		'node-debug2-adapter',
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
	},
}

require('docs-view').setup {}

require('nvim-lightbulb').setup {
	ignore = {},
	sign = {
		enabled = true,
		-- Priority of the gutter sign
		priority = 10,
	},
	autocmd = {
		enabled = true,
		-- see :help autocmd-pattern
		pattern = { '*' },
		-- see :help autocmd-events
		events = { 'CursorHold', 'CursorHoldI' },
	},
}
-- Golang
if dtextobjects_ok then
	dtextobjects.setup { create_default_keymaps = false }
	vim.keymap.set({ 'x', 'o', 'n' }, ']d', function()
		require('textobj-diagnostic').next_diag()
	end, { silent = true })
	vim.keymap.set({ 'x', 'o', 'n' }, '[d', function()
		require('textobj-diagnostic').prev_diag()
	end, { silent = true })
-- vim.keymap.set({ 'x', 'o', 'n' }, 'id', function()
-- 	require('textobj-diagnostic').next_diag_inclusive()
-- end, { silent = true })
else
	print('No diagnostic text objects')
end

if prettier_ok then
	prettier.setup {
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
	}
end

local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
vim.o.code_action_menu_window_border = 'single'
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
