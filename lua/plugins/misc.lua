local M = {}

M.ccc = function()
	local ccc_ok, ccc = pcall(require, 'ccc')

	if not ccc_ok then
		print('no ccc')
		return
	end
	ccc.setup {
		highlighter = {
			auto_enable = true,
		},
	}
end

return M
