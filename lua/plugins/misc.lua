local M = { -- COLOR-PICKER
	{
		'uga-rosa/ccc.nvim',
		opts = {
			highlighter = {
				auto_enable = true,
			},
		},
	},
	{ -- NVIM-RECORDER
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

	'sitiom/nvim-numbertoggle',
	'mong8se/actually.nvim',
	'ralismark/vim-recover',
	{ -- toggleterm
		'akinsho/toggleterm.nvim',
    cond = vim.g.started_by_firenvim == nil,
		keys = { '<C-\\>' },
		opts = {
			open_mapping = [[<c-\>]],
		},
	},
	{
		'chentoast/marks.nvim',
		config = true,
	},
	{ -- nvim-surround
		'kylechui/nvim-surround',
		config = true,
	},
	{
		'cvigilv/esqueleto.nvim',
    cond = vim.g.started_by_firenvim == nil,
		opts = {
			directory = '~/.config/nvim/templates',
			patterns = { 'org' },
		},
	},
	{
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
	-- { -- vim-skeleton
	--   'noahfrederick/vim-skeleton',
	--   config = function()
	--     vim.cmd([[let g:skeleton_template_dir = "~/.config/nvim/templates"]])
	--   end,
	-- },
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
			},
		},
	},
	{ --Sniprun
		'michaelb/sniprun',
    cond = vim.g.started_by_firenvim == nil,
		build = 'bash ./install.sh',
	},
	{ -- Lastplace: remember last place in file
		'ethanholz/nvim-lastplace',
    cond = vim.g.started_by_firenvim == nil,
		opts = {
			lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help', 'Trouble', 'terminal', 'nvimtree' },
			lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
			lastplace_open_folds = true,
		},
	},
	{ -- scrollbar
		'petertriho/nvim-scrollbar',
		opts = {
			handlers = {
				diagnostic = true,
				search = true, -- Requires hlslens to be loaded
				gitsigns = true, -- Requires gitsigns.nvim
			},
		},
	},
	{ -- tint.nvim
		'levouh/tint.nvim',
		config = true,
	},
	{
		'EricDriussi/remember-me.nvim',
    cond = vim.g.started_by_firenvim == nil,
		config = true,
	},
	{
		'gbprod/yanky.nvim',
		opts = {
			highlight = {
				timer = 200,
			},
			preserve_cursor_position = {
				enabled = true,
			},
			ring = {
				cancel_event = 'move',
			},
		},

		config = function(opts)
			require('yanky').setup(opts)
		end,
		keys = {
			{ 'y', '<Plug>(YankyYank)', desc = 'YankeeYank' },
			{ 'p', '<Plug>(YankyPutAfter)', desc = 'YankyPutAfter' },
			{ 'P', '<Plug>(YankyPutBefore)', desc = 'YankyPutBefore' },
			{ 'gp', '<Plug>(YankyGPutAfter)', desc = 'YankyGPutAfter' },
			{ 'gP', '<Plug>(YankyGPutBefore)', desc = 'YankyGPutBefore' },
			{ '<c-j>', '<Plug>(YankyCycleForward)', desc = 'YankyCycleForward' },
			{ '<c-k>', '<Plug>(YankyCycleBackward)', desc = 'YankyCycleBackward' },
			{ ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'YankyPutIndentAfterLinewise' },
			{ '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'YankyPutIndentBeforeLinewise' },
			{ ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'YankyPutIndentAfterLinewise' },
			{ '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'YankyPutIndentBeforeLinewise' },

			{ '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'YankyPutIndentAfterShiftRight' },
			{ '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'YankyPutIndentAfterShiftLeft' },
			{ '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'YankyPutIndentBeforeShiftRight' },
			{ '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'YankyPutIndentBeforeShiftLeft' },

			{ '=p', '<Plug>(YankyPutAfterFilter)', desc = 'YankyPutAfterFilter' },
			{ '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'YankyPutBeforeFilter' },
		},
	},
}

return M
