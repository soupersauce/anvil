--
local M = {
	'nvim-lua/plenary.nvim',
	'folke/lazy.nvim',

	{ -- firenvim
		'glacambre/firenvim',
		event = 'BufEnter',
		build = function()
			vim.fn['firenvim#install'](0)
		end,
		config = function()
			vim.g.firenvim_config = {
				globalSettings = {
					['.*'] = {
						cmdline = 'neovim',
					},
				},
				localSettings = {
					['.*'] = {
						cmdline = 'neovim',
						content = 'text',
						priority = 0,
						selector = 'textarea',
						takeover = 'never',
					},
				},
			}
		end,
	},
	{
	{
		'willothy/moveline.nvim',
		build = 'make',
		keys = {
			{
				'<leader>k',
				function()
					require('moveline').up()
				end,
				'moveline.up',
			},
			{
				'<leader>j',
				function()
					require('moveline').down()
				end,
				'moveline.down',
			},
			{
				'<leader>k',
				function()
					require('moveline').block_up()
				end,
				'moveline.up',
			},
			{
				'<leader>j	-- Insert Dependencies here',
				function()
					require('moveline').block_down()
				end,
				'moveline.down',
			},
		},
	},
	{
		'Bekaboo/deadcolumn.nvim',
	},
	{
		'bennypowers/splitjoin.nvim',
		lazy = true,
		keys = {
			{
				'gj',
				function()
					require('splitjoin').join()
				end,
				desc = 'Join the object under cursor',
			},
			{
				'g,',
				function()
					require('splitjoin').split()
				end,
				desc = 'Split the object under cursor',
			},
		},
	},
	{ -- neoclip telescope yank history
		'AckslD/nvim-neoclip.lua',
		config = true,
	},
	{ -- miniyank
		'bfredl/nvim-miniyank',
		keys = {
			{ 'p', '<Plug>(miniyank-autoput)', desc = 'Miniyank put' },
			{ 'P', '<Plug>(miniyank-autoPut)', desc = 'Miniyank Put' },
			{ '<C-j>', '<Plug>(miniyank-cycle)', desc = 'Miniyank cycle' },
			{ '<C-k>', '<Plug>(miniyank-cycleback)', desc = 'Miniyank cycleback' },
		},
	},
	{ -- bufdelete
		'famiu/bufdelete.nvim',
		keys = {
			{
				'bd',
				function()
					require('bufdelete').bufdelete(0, true)
				end,
				desc = 'Delete Current buffer',
			},
		},
	},
	-- Syntaxes
	'sqwishy/vim-sqf-syntax', -- Sqf for arma3
	'ledger/vim-ledger', -- Ledger filetype
}

return M
