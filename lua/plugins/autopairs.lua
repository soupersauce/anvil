local M = {
	{
		'windwp/nvim-autopairs',
		opts = {
			fast_wrap = {},
			check_ts = true,
			disable_filetype = { 'alpha', 'vim', 'NvimTree', 'TelescopePrompt' },
			ts_config = {
				lua = { 'string' },
				javascript = { 'template_string' },
				java = false,
				rust = {},
			},
		},
		config = function(opts)
			local autopairs = require('nvim-autopairs')
			local Rule = require('nvim-autopairs.rule')

			require('nvim-autopairs').setup(opts)

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
				Rule('<', '>', { 'rust' })
					:with_pair(cond.before_regex('%a+'))
					:with_pair(cond.not_after_regex('%a'))
					:with_move(ts_conds.is_ts_node { 'type_arguments', 'type_parameters' }),
				-- don't add a pair if  the next character is =
				-- :with_pair(cond.not_before_char("="))
				-- don't add a pair if the next character is =
				-- :with_pair(cond.not_after_char("="))
				-- :with_move(function(opts)
				--   if ((opts.prev_char:match('.%>') ~= nil) and (opts.prev_char:match('=') == nil)) then
				--     return true
				--   end
				-- end)
			}
		end,
	},
}

return M
