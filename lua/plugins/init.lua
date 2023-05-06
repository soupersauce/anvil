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
