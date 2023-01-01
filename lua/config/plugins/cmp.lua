local M = { -- CMP
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			-- 'KadoBOT/cmp-plugins',
			'onsails/lspkind.nvim',
			'nvim-autopairs',
			'nvim-web-devicons',
			'yamatsum/nvim-nonicons',
			-- 'uga-rosa/cmp-dictionary',
			-- 'hrsh7th/cmp-nvim-lsp',
			-- 'hrsh7th/cmp-nvim-lua',
			-- 'hrsh7th/cmp-buffer',
			-- 'hrsh7th/cmp-cmdline',
			-- 'dmitmel/cmp-cmdline-history',
			-- 'petertriho/cmp-git',
			-- 'andersevenrud/cmp-tmux',
			-- 'rcarriga/cmp-dap', dependencies = 'hrsh7th/nvim-cmp',
			-- 'quangnguyen30192/cmp-nvim-tags',
			-- 'saadparwaiz1/cmp_luasnip',
			-- 'f3fora/cmp-spell',
			-- 'tamago324/cmp-zsh',
		},
}
function M.config()
			local vim = vim
			local icons = require('ui.icons')
			local lspkind = require('lspkind')
			vim.o.completeopt = 'menuone,noselect'
			-- Setup nvim-cmp.
			local _, cmp = pcall(require, 'cmp')
			local _, luasnip = pcall(require, 'luasnip')
			local _, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
			end

			local types = require('cmp.types')

      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
			cmp.setup {

				completion = {
					autocomplete = {
						types.cmp.TriggerEvent.InsertEnter,
						-- types.cmp.TriggerEvent.TextChanged,
					},
					completeopt = 'menu,menuone,noselect',
					-- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
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
						-- behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					},
					['<C-e'] = cmp.mapping.close(),
					-- Super Tab
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
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
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},

				sources = cmp.config.sources {
					{ name = 'nvim_lua' },
					{ name = 'nvim_lsp' },
					{ name = 'plugins' },
					{ name = 'luasnip' },
					{ name = 'crates' },
					{ name = 'cmp_autopairs' },
					{ name = 'path' },
					-- { name = 'buffer', keyword_length = 3 },
					-- { name = 'dictionary', keyword_length = 2 },
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
			for _, cmd_type in ipairs { '/', '?', '@' } do
				cmp.setup.cmdline(cmd_type, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = 'cmdline_history' },
						{ name = 'buffer' },
					},
					view = {
						entries = { name = 'custom' },
					},
				})
			end

			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'cmdline' },
					{ name = 'nvim_lua' },
					{ name = 'cmdline_history' },
					{ name = 'path' },
					{ name = 'plugins' },
				},
				view = {
					entries = { name = 'custom', selection_order = 'near_cursor' },
				},
			})

			cmp.setup.filetype('gitcommit', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources {
					{ name = 'git' },
					{ name = 'commit' },
					{ name = 'buffer' },
					{ name = 'dictionary' },
				},
			})

			cmp.setup.filetype('NeogitCommitMessage', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources {
					{ name = 'git' },
					{ name = 'commit' },
					{ name = 'buffer' },
					{ name = 'dictionary' },
				},
			})

			cmp.setup.filetype('org', {
				mapping = cmp.mapping.preset.insert(),
				sources = cmp.config.sources {
					{ name = 'org' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'dictionary' },
				},
			})
		end
return M
