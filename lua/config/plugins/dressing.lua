local M = { -- dressing
	'stevearc/dressing.nvim',
	dependencies = 'MunifTanjim/nui.nvim',
}

function M.config()
	local dressing_ok, dressing = pcall(require, 'dressing')

	dressing.setup {
		select = {
			backend = { 'fzf_lua', 'fzf', 'nui', 'telescope', 'builtin' },
		},
	}
end
return M
