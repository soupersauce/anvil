local todo_ok, todo = pcall(require, 'todo-comments')

if not todo_ok then
	return
end

todo.setup {
	highlight = {
		exclude = { 'vim', 'packer', 'NeogitStatus', 'NeogitPopup', 'nofile', 'terminal' },
	},
}
