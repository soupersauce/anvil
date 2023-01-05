local M = { -- Comment.nvim
	'numToStr/Comment.nvim',
}

function M.config()
	local status_ok, comment = pcall(require, 'Comment')
	comment.setup {
		pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),

		ignore = '^$',
	}
end

return M
