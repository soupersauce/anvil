-- Auto commands use sparingly, having auto commands that trigger often may
-- slow down nvim
local vim = vim
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight current line on active window only
local active_line_highligh = augroup('HighlightActiveLine', { clear = true })
autocmd('WinEnter', {
	desc = 'show cursorline',
	callback = function()
		vim.wo.cursorline = true
	end,
	group = active_line_highligh,
})
autocmd('WinLeave', {
	desc = 'hide cursorline',
	callback = function()
		vim.wo.cursorline = false
	end,
	group = active_line_highligh,
})

-- Highlight yanked text
-- local highlight_yank = augroup('HighlightYank', { clear = true })
-- autocmd('TextYankPost', {
-- 	desc = 'highlight yanked text',
-- 	callback = function()
-- 		vim.highlight.on_yank { higroup = 'IncSearch', timeout = 50 }
-- 	end,
-- 	group = highlight_yank,
-- })

-- autocmd('BufWritePost', {
-- 	pattern = '*/plugins/*.lua',
-- 	callback = function()
-- 		vim.cmd([[source ~/.config/nvim/lua/plugins/init.lua | PackerCompile<CR><CR>]])
-- 	end,
-- })
