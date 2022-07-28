-- local undo_ok, undo = pcall(require, 'undotree')
local undo = require('undotree')
-- if not undo_ok then
-- 	print('No Undotree')
-- 	return
-- end

undo.setup {
	float_diff = true,
}

-- vim.keymap.set('n', '<leader>u', 'require("undotree").toggle()', { noremap = true })
