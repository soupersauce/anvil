local M = { -- Comment.nvim
	{
		'numToStr/Comment.nvim',
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
