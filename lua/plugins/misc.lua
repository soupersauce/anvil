local M = {
	{ -- nvim-recorder
		'chrisgrieser/nvim-recorder',
		cond = vim.g.started_by_firenvim == nil,
		config = function()
			require('recorder').setup {
				slots = { 'a', 'b', 'c' },
				-- Default Mappings
				mapping = {
					startStopRecording = 'q',
					playMacro = 'Q',
					editMacro = 'cq',
					switchSlot = '<C-q>',
					addBreakPoint = '#',
				},
			}
		end,
	},
	-- tim pope
	'tpope/vim-unimpaired',
	'tpope/vim-repeat',
	'tpope/vim-fugitive',
	'tpope/vim-eunuch',
	'tpope/vim-vinegar',

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
		build = 'bash ./install.sh',
	},
}
return M
