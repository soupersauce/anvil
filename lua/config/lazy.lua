local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- local run_sync = false
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--depth',
		'1',
		'https://github.com/folke/lazy.nvim.git',
		lazypath,
	}
end
vim.opt.runtimepath:prepend(lazypath)

local lazyopts = {
	defaults = { lazy = false },
	install = {},
	checker = {
		enabled = true,
		notify = false,
	},
	diff = {
		cmd = 'diffview.nvim',
	},
	performance = {
		cache = {
			enabled = true,
			-- disable_events = {},
		},
	},
}

require('lazy').setup('plugins', lazyopts)
vim.keymap.set('n', '<leader>l', '<cmd>:Lazy<cr>')
