local M = {
	'folke/todo-comments.nvim',
}
function M.config()
	local todo_ok, todo = pcall(require, 'todo-comments')

	todo.setup {
		highlight = {
			exclude = { 'vim', 'packer', 'NeogitStatus', 'NeogitPopup', 'nofile', 'terminal' },
		},
	}
end
return M
