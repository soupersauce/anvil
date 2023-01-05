local M = {
	'kevinhwang91/nvim-hlslens',
}

function M.config()
	local vim = vim
	require('hlslens').setup {
		build_position_cb = function(plist, _, _, _)
			require('scrollbar.handlers.search').handler.show(plist.start_pos)
		end,
	}
	local kopts = { noremap = true, silent = true }

	vim.keymap.set(
		'n',
		'n',
		[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
		kopts
	)
	vim.keymap.set(
		'n',
		'N',
		[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
		kopts
	)
	vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
	vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
	vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
	vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

	vim.cmd([[
        augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
        augroup END
    ]])
	vim.keymap.set('n', '<Leader>l', ':noh<CR>', kopts)
end

return M
