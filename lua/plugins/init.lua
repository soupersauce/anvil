-- PLUGIN SETTINGS
--
local M = {
	'lewis6991/impatient.nvim',
	'nvim-lua/plenary.nvim',
	'folke/lazy.nvim',

	{ -- VARIOUS_TEXTOBJS:
		'chrisgrieser/nvim-various-textobjs',
		opts = { useDefaultKeymaps = true },
	},
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
	{
		'stevearc/oil.nvim',
		config = true,
	},
	-- Syntaxes
	'sqwishy/vim-sqf-syntax', -- Sqf for arma3
	{
		'tridactyl/vim-tridactyl', -- for tridactyl firefox plugin
		event = 'bufReadPre tridactylrc',
		config = function()
			vim.api.nvim_create_autocmd({ 'bufRead' }, {
				pattern = 'tridactylrc',
				command = 'set ft=tridactylrc',
			})
		end,
	},
}

return M
