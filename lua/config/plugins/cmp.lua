local M = { -- CMP
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  config = function()
			local cmp_ok, cmp = pcall(require, 'cmp')
      if not cmp_ok then
        vim.notify('cmp not loaded')
        return
      end
			local icons = require('ui.icons')
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
							cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Select })
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
							cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Select })
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
  end
}

return M
