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

	-- Syntaxes
	'sqwishy/vim-sqf-syntax', -- Sqf for arma3
	'tridactyl/vim-tridactyl', -- for tridactyl firefox plugin
}

-- { -- netman.nvim
-- 	'miversen33/netman.nvim',
-- 	branch = 'issue-28-libuv-shenanigans',
-- 	config = function()
-- 		require('netman')
-- 	end,
-- }

return M
