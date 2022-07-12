local undo_ok, undotree = pcall(require, 'undotree')
if not undo_ok then
	print('No Undotree')
	return
end

undotree.setup {}

vim.keymap.set('n', '<leader>u', 'require("undotree").toggle()', { noremap = true })
