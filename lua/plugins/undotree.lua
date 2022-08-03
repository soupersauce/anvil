local undo_ok, undotree = pcall(require, 'undotree')
if not undo_ok then
	print('No Undotree')
	return
end

undotree.setup {
	float_diff = true,
}
