local M = {
	{
		'ecthelionvi/NeoComposer.nvim',
		dependencies = { 'kkharji/sqlite.lua' },
		opts = {},
	},
	-- tim pope
	'tpope/vim-unimpaired',
	'tpope/vim-repeat',
	'tpope/vim-fugitive',
	'tpope/vim-eunuch',
	'tpope/vim-vinegar',
	'tpope/vim-abolish',

	{ -- toggleterm
		'akinsho/toggleterm.nvim',
		cond = vim.g.started_by_firenvim == nil,
		keys = { '<C-\\>' },
		opts = {
			open_mapping = [[<c-\>]],
		},
	},
	{ -- nvim-surround
		'kylechui/nvim-surround',
		config = true,
	},
	{ -- ssr
		'cshuaimin/ssr.nvim',
		keys = {
			{
				'<leader>sR',
				function()
					require('ssr').open()
				end,
				mode = { 'n', 'x' },
				desc = 'Structural Replace',
			},
		},
	},
	{ -- toggler
		'nat-418/boole.nvim',
		keys = {
			{ '<C-a>' },
			{ '<C-x>' },
		},
		opts = {
			mappings = {
				increment = '<C-a>',
				decrement = '<C-x>',
			},
			additions = {
				{ 'increment', 'decrement' },
				{ 'previous', 'next' },
				{ 'up', 'next' },
			},
		},
	},
	{ --Sniprun
		'michaelb/sniprun',
		cond = vim.g.started_by_firenvim == nil,
		cmd = { 'SnipRun', 'SnipInfo' },
		build = 'bash ./install.sh',
	},
}
return M
