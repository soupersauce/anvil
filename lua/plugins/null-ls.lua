local M = {
	'jose-elias-alvarez/null-ls.nvim',
}
function M.setup(options)
	local _, nls = pcall(require, 'null-ls')

	local with_root_file = function(...)
		local files = { ... }
		return function(util)
			return util.root_has_file(files)
		end
	end

	local diagnostics_code_template = '#{m} [#{c}]'

	local cactions = nls.builtins.code_actions
	local diag = nls.builtins.diagnostics
	local format = nls.builtins.formatting
	local hover = nls.builtins.hover

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
		diag.codespell.with {
			extra_args = { '-I', vim.fn.expand('~/.config/codespellignore') },
		},
		diag.commitlint,
		diag.curlylint,
		diag.gitlint,
		diag.golangci_lint,
		diag.hadolint,
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
		diag.selene.with {
			conditions = with_root_file('selene.toml'),
		},
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
			extra_args = function()
				-- if with_root_file('.vale.ini') then
				-- 	return { '--config', require('null-ls.utils').get_root() .. '.vale.ini' }
				if vim.g.started_by_firenvim then
					return { '--config', vim.fn.expand('~/.vale.ini') }
				else
					return nil
				end
			end,
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
		-- format.codespell,
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
	nls.setup {
		debounce = 150,
		debug = true,
		save_after_format = false,
		sources = null_sources,
		on_attach = options.on_attach,
	}
end

return M
