local M = { -- Comment.nvim
	{
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
}

return M
