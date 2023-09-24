local M = {
	{ -- cmp
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		config = function()
			local cmp = require('cmp')
			local icons = require('icons')
			local lspkind = require('lspkind')
			vim.o.completeopt = 'menu,menuone,noinsert'
			-- Setup nvim-cmp.
			local luasnip = require('luasnip')
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
			end

			local types = require('cmp.types')

			cmp.setup {
				completion = {
					autocomplete = {
						types.cmp.TriggerEvent.InsertEnter,
						types.cmp.TriggerEvent.TextChanged,
					},
					completeopt = 'menu,menuone,noinsert,noselect',
					keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
					keyword_length = 0,
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body) -- Use LuaSnip.
					end,
				},
				mapping = cmp.mapping.preset.insert {
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-j>'] = cmp.mapping.select_next_item { behavior = types.cmp.SelectBehavior.Select },
					['<C-k>'] = cmp.mapping.select_prev_item { behavior = types.cmp.SelectBehavior.Select },
					['<C-Space>'] = cmp.mapping.complete {},
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					},
					['<C-e'] = cmp.mapping.abort(),
					-- Super Tab
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item { behavior = types.cmp.SelectBehavior.Select }
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item { behavior = types.cmp.SelectBehavior.Select }
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},

				sources = cmp.config.sources {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'crates' },
					{ name = 'tmux' },
					{ name = 'cmp_autopairs' },
					{ name = 'path' },
					{ name = 'buffer', keyword_length = 3 },
					{ name = 'dictionary', keyword_length = 3 },
					{ name = 'kitty' },
				},

				formatting = {
					format = lspkind.cmp_format {
						mode = 'symbol_text',
						menu = {
							nvim_lua = '[nvim]',
							nvim_lsp = '[lsp]',
							luasnip = '[snip]',
							buffer = '[buf]',
							path = '[path]',
							orgmode = '[org]',
							cmdline = '[:cmd]',
							cmdline_history = '[:hist]',
							cmp_git = '[git]',
							dictionary = '[dict]',
							spell = '[spell]',
							plugins = '[plg]',
						},
					},
				},

				experimental = {
					ghost_text = {
						hl_group = 'LspCodeLens',
					},
				},
				window = {
					winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
					col_offset = -3,
					side_padding = 0,
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.sort_text,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.kind,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			}
			cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

			for _, cmd_type in ipairs { '/', '?', '@' } do
				cmp.setup.cmdline(cmd_type, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = 'buffer' },
						{ name = 'cmdline_history' },
					},
					view = {
						entries = { name = 'custom', selection_order = 'near_cursor' },
					},
				})
			end

			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'cmdline' },
					{ name = 'cmdline_history' },
					{ name = 'nvim_lua' },
					{ name = 'path' },
					{ name = 'plugins' },
				},
				view = {
					entries = { name = 'custom', selection_order = 'near_cursor' },
				},
			})

			for _, cmd_ft in ipairs { 'gitcommit', 'NeogitCommitMessage' } do
				cmp.setup.filetype(cmd_ft, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources {
						{ name = 'git' },
						{ name = 'commit' },
						{ name = 'buffer' },
						{ name = 'dictionary' },
					},
				})
			end

			cmp.setup.filetype('org', {
				mapping = cmp.mapping.preset.insert(),
				sources = cmp.config.sources {
					{ name = 'orgmode' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'dictionary' },
				},
			})

			cmp.setup.filetype('lua', {
				mapping = cmp.mapping.preset.insert(),
				sources = cmp.config.sources {
					{ name = 'plugins' },
					{ name = 'luasnip' },
					{ name = 'nvim_lua' },
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
				},
			})
		end,
	},
	{ -- cmp-dictionary
		'uga-rosa/cmp-dictionary',
		opts = {
			dic = {
				['*'] = { '~/.config/nvim/dictionaries/aspell_en' },
			},
			async = true,
			max_items = 10,
		},
	},
	{ -- cmp-plugins
		'KadoBOT/cmp-plugins',
		opts = {
			files = { '.*\\.lua' }, -- default
			-- files = { "plugins.lua", "some_path/plugins/" } -
		},
	},
	{ -- cmp-git
		'petertriho/cmp-git',
		config = true,
	},
	{ -- cmp_kitty
		'garyhurtz/cmp_kitty',
		dependencies = 'hrsh7th/nvim-cmp',
		init = function()
			require('cmp_kitty'):setup()
		end,
	},
	'kirasok/cmp-hledger',
	'saadparwaiz1/cmp_luasnip',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-nvim-lua',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-cmdline',
	'dmitmel/cmp-cmdline-history',
	'andersevenrud/cmp-tmux',
	'f3fora/cmp-spell',
	'tamago324/cmp-zsh',
	'Dosx001/cmp-commit',
	'hrsh7th/cmp-path',
	-- 'rcarriga/cmp-dap',
	'rafamadriz/friendly-snippets',
	{ -- luasnip
		'L3MON4D3/LuaSnip',
		config = function()
			local augroup = vim.api.nvim_create_augroup
			local autocmd = vim.api.nvim_create_autocmd
			local luasnip = require('luasnip')
			local types = require('luasnip.util.types')
			local options = { silent = false, noremap = true, desc = 'luasnip' }

			-- Load snippets provided by extensions
			require('luasnip.loaders.from_vscode').lazy_load()

			-- Load custom snippets
			local snippet_dir = vim.fn.stdpath('config') .. '/snippets'
			require('luasnip.loaders.from_vscode').lazy_load { paths = { snippet_dir } }

			luasnip.filetype_extend('javascriptreact', { 'html', 'react' })
			luasnip.filetype_extend('typescriptreact', { 'html', 'react-ts' })
			luasnip.filetype_extend('vue', { 'html', 'javascript', 'pug' })
			luasnip.filetype_extend('ruby', { 'rails' })

			local to_completion = function(snippet)
				return {
					word = snippet.trigger,
					menu = snippet.name,
					info = vim.trim(
						table.concat(vim.tbl_flatten { snippet.dscr or '', '', snippet:get_docstring() }, '\n')
					),
					dup = true,
					user_data = 'luasnip',
				}
			end

			local snippetfilter = function(line_to_cursor, base)
				return function(s)
					return not s.hidden and vim.startswith(s.trigger, base) and s.show_condition(line_to_cursor)
				end
			end

			-- Set 'completefunc' or 'omnifunc' to 'v:lua.completefunc' to get snippet completion.
			function completefunc(findstart, base)
				local line, col = vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)[2]
				local line_to_cursor = line:sub(1, col)

				if findstart == 1 then
					return vim.fn.match(line_to_cursor, '\\k*$')
				end

				local snippets =
					vim.list_extend(vim.list_slice(luasnip.get_snippets('all')), luasnip.get_snippets(vim.bo.filetype))
				snippets = vim.tbl_filter(snippetfilter(line_to_cursor, base), snippets)
				snippets = vim.tbl_map(to_completion, snippets)
				table.sort(snippets, function(s1, s2)
					return s1.word < s2.word
				end)
				return snippets
			end

			local luasnip_expand = augroup('LuaSnip-expand', { clear = true })
			autocmd('CompleteDone', {
				desc = 'expand snippet after selecting completion option',
				callback = function()
					if vim.v.completed_item.user_data == 'luasnip' and luasnip.expandable() then
						luasnip.expand()
					end
				end,
				group = luasnip_expand,
			})

			vim.o.completefunc = 'v:lua.completefunc'

			luasnip.config.setup {
				ext_opts = {
					[types.choiceNode] = {
						active = {
							virt_text = { { '●', 'Statement' } },
						},
					},
					[types.insertNode] = {
						active = {
							virt_text = { { '●', 'Identifier' } },
						},
					},
				},
			}
		end,
	},
}

return M
