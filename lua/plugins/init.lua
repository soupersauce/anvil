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
		build = function()
			vim.fn['firenvim#install'](0)
		end,
		config = function()
			vim.cmd([[
        let g:firenvim_config = {
            \ 'globalSettings': {
                \ 'ignoreKeys': {
                    \ 'all': ['<C-,'],
                \ }
            \ }
        \ }
    ]])
		end,
	},

	-- Syntaxes
	'sqwishy/vim-sqf-syntax', -- Sqf for arma3
	'tridactyl/vim-tridactyl', -- for tridactyl firefox plugin
}

return M
