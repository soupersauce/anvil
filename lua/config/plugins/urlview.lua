local M = { -- URLView
	'axieax/urlview.nvim',
}

function M.config()
	local url_ok, urlview = pcall(require, 'urlview')

	local actions = require('urlview.actions')

	actions['wslopen'] = function(raw_url)
		-- local url = vim.fn.shellescape(raw_url)
		actions.shell_exec('wsl-open', raw_url)
	end

	urlview.setup {
		default_action = 'system',
		sorted = 'false',
	}
end
return M
