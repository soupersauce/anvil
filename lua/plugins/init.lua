-- PLUGIN SETTINGS
--
local M = {
	'nvim-lua/plenary.nvim',
	'folke/lazy.nvim',

	{
		'glacambre/firenvim',
		event = 'BufEnter',
		after = 'folke/noice.nvim',
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
						-- takeover = 'always',
					},
				},
			}
		end,
	},
	{
		'EtiamNullam/deferred-clipboard.nvim',
		opts = {
			lazy = true,
			fallback = 'unnamedplus',
		},
	},
	{
		'bfredl/nvim-miniyank',
		keys = {
			{ 'p', '<Plug>(miniyank-autoput)', desc = 'Miniyank put' },
			{ 'P', '<Plug>(miniyank-autoPut)', desc = 'Miniyank Put' },
			{ '<C-j>', '<Plug>(miniyank-cycle)', desc = 'Miniyank cycle' },
			{ '<C-k>', '<Plug>(miniyank-cycleback)', desc = 'Miniyank cycleback' },
		},
	},
	{
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
}

return M
