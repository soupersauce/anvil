local M = { -- COLOR-PICKER
	'uga-rosa/ccc.nvim',
}

M.config = function()
	local ccc_ok, ccc = pcall(require, 'ccc')

	ccc.setup {
		highlighter = {
			auto_enable = true,
		},
	}
end

return M
