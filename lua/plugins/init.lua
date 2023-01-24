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

	-- Syntaxes
	'sqwishy/vim-sqf-syntax', -- Sqf for arma3
	'tridactyl/vim-tridactyl', -- for tridactyl firefox plugin
}

return M
