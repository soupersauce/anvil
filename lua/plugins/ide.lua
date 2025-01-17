local M = {
	-- lspkind
	'onsails/lspkind.nvim',
	{ -- blankline
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		config = function()
			local highlight = {
				'RainbowRed',
				'RainbowYellow',
				'RainbowBlue',
				'RainbowOrange',
				'RainbowGreen',
				'RainbowViolet',
				'RainbowCyan',
			}
			local hooks = require('ibl.hooks')
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
				vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
				vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
				vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
				vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
				vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
				vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }
			require('ibl').setup { scope = { highlight = highlight } }

			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end,
	},
	{ -- ufo
		'kevinhwang91/nvim-ufo',
		-- cond = vim.g.started_by_firenvim == nil,
		dependencies = 'kevinhwang91/promise-async',
		keys = {
			{
				'zR',
				function()
					require('ufo').openAllFolds()
				end,
				desc = 'UfoOpenAll',
			},
			{
				'zM',
				function()
					require('ufo').closeAllFolds()
				end,
				desc = 'UfoCloseAll',
			},
			{
				'zr',
				function()
					require('ufo').openFoldsExceptKinds()
				end,
				desc = 'UfoOpenExcept',
			},
			{
				'zm',
				function()
					require('ufo').closeFoldsWith()
				end,
				desc = 'UfoCloseWith',
			}, -- closeAllFolds == closeFoldsWith(0)
		},
		config = function()
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (' 祉%d '):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, 'MoreMsg' })
				return newVirtText
			end

			-- If you disable this autocmd and some folds in org files won't close
			-- This is why. TODO: see if we can make it work?
			vim.api.nvim_create_autocmd({ 'FileType' }, {
				pattern = { 'org' },
				callback = function()
					require('ufo').detach()
				end,
			})

			require('ufo').setup {
				provider_selector = function(bufnr, filetype, buftype)
					return { 'lsp', 'indent' }
				end,
				fold_virt_text_handler = handler,
			}
		end,
	},
	{ -- SEARCH AND REPLACE
		's1n7ax/nvim-search-and-replace',
		config = function()
			require('nvim-search-and-replace').setup()
		end,
	},
	{ -- web-devicons:
		'nvim-tree/nvim-web-devicons',
		opts = { default = true },
	},
	{ -- comment-nvim
		'numToStr/Comment.nvim',
		cond = vim.g.started_by_firenvim == nil,
		dependencies = 'joosepalviste/nvim-ts-context-commentstring',
		opts = {
			hook = function()
				require('ts_context_commentstring.internal').update_commentstring()
			end,
			-- pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),

			ignore = '^$',
		},
	},
	{ -- autopairs
		'windwp/nvim-autopairs',
		config = function()
			local autopairs = require('nvim-autopairs')
			local Rule = require('nvim-autopairs.rule')

			require('nvim-autopairs').setup {
				fast_wrap = {
					map = '<M-e>',
					chars = { '{', '[', '(', '"', "'" },
					pattern = [=[[%'%"%)%>%]%)%}%,]]=],
					end_key = '$',
					keys = 'qwertyuiopzxcvbnmasdfghjkl',
					check_comma = true,
					highlight = 'Search',
					highlight_grey = 'Comment',
				},
				check_ts = true,
				disable_filetype = { 'alpha', 'vim', 'NvimTree', 'TelescopePrompt' },
				ts_config = {
					javascript = { 'template_string' },
					java = false,
					rust = {},
				},
			}

			local ts_conds = require('nvim-autopairs.ts-conds')
			local cond = require('nvim-autopairs.conds')

			autopairs.add_rules {
				Rule('%', '%', 'lua'):with_pair(ts_conds.is_ts_node { 'string', 'comment' }),
				Rule('$', '$', 'lua'):with_pair(ts_conds.is_ts_node { 'function' }),
				-- Add padding when space entered after opening pair
				Rule(' ', ' '):with_pair(function(opts)
					local pair = opts.line:sub(opts.col - 1, opts.col)
					return vim.tbl_contains({ '()', '[]', '{}' }, pair)
				end),
				Rule('( ', ' )')
					:with_pair(function()
						return false
					end)
					:with_move(function(opts)
						return opts.prev_char:match('.%)') ~= nil
					end)
					:use_key(')'),
				Rule('{ ', ' }')
					:with_pair(function()
						return false
					end)
					:with_move(function(opts)
						return opts.prev_char:match('.%}') ~= nil
					end)
					:use_key('{'),
				Rule('[ ', ' ]')
					:with_pair(function()
						return false
					end)
					:with_move(function(opts)
						return opts.prev_char:match('.%]') ~= nil
					end)
					:use_key('['),
			}
		end,
	},
}
return M
