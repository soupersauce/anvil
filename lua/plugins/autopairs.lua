local M = {
	{
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
