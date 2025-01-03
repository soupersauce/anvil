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

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
	group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
	callback = function(event)
		local file = vim.loop.fs_realpath(event.match) or event.match

		vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
		local backup = vim.fn.fnamemodify(file, ':p:~:h')
		backup = backup:gsub('[/\\]', '%%')
		vim.go.backupext = backup
	end,
})

-- set spell for certain filetypes
vim.api.nvim_create_autocmd({ 'FileType' }, {
	pattern = { 'markdown', 'org', 'tex', 'text' },
	callback = function()
		vim.wo.spell = true
	end,
})

-- Fix conceallevel for json & help files
vim.api.nvim_create_autocmd({ 'FileType' }, {
	pattern = { 'json', 'jsonc' },
	callback = function()
		vim.wo.spell = false
		vim.wo.conceallevel = 0
	end,
})
-- Highlight yanked text
local highlight_yank = augroup('HighlightYank', { clear = true })
autocmd('TextYankPost', {
	desc = 'highlight yanked text',
	callback = function()
		vim.highlight.on_yank { higroup = 'IncSearch', timeout = 50 }
	end,
	group = highlight_yank,
})
-- TODO: This should replace lastplace but I need a way to ignore certain buffers
-- vim.api.nvim_create_autocmd('BufReadPost', {
--   callback = function()
--     local mark = vim.api.nvim_buf_get_mark(0, '"')
--     local lcount = vim.api.nvim_buf_line_count(0)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })
