local M = { -- URLView
	'axieax/urlview.nvim',
  cmd = 'UrlView'
}

function M.config()
	local _, urlview = pcall(require, 'urlview')

	local actions = require('urlview.actions')

	-- actions['wslopen'] = function(raw_url)
	-- 	-- local url = vim.fn.shellescape(raw_url)
	-- 	actions.shell_exec('wsl-open', raw_url)
	-- end

	urlview.setup {
		default_action = 'system',
		sorted = 'false',
	}
end
function M.init()
  vim.keymap.set('n', '<leader>U', "<cmd>UrlView<CR>", { desc = 'Buffer URLs' })
  vim.keymap.set('n', '<leader>Ul', "<cmd>UrlView lazy<CR>", { desc = 'Lazy URLs' })
end
return M
