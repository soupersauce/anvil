local M = {
	{ -- TELESCOPE:
		'nvim-telescope/telescope.nvim',
		cmd = { 'Telescope' },
		dependencies = {
			'kyazdani42/nvim-web-devicons',
		},
		config = function()
			-- Telescope configuration
			local telescope = require('telescope')
			local telescope_builtin = require('telescope.builtin')

			telescope.setup {
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = 'smart_case', -- other options: 'ignore_case' or 'respect_case'
					},
					undo = {},
				},
			}

			telescope.load_extension('fzf')
			telescope.load_extension('undo')
			-- telescope.load_extension('dap')
		end,
		keys = {
			{
				'<leader>u',
				function()
					require('telescope').extensions.undo.undo()
				end,
				desc = 'Telescope Undo',
			},
		},
	},
	{ -- TELESCOPE-FZF-NATIVE:
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
	},
	-- TELESCOPE-UNDO:
	'debugloop/telescope-undo.nvim',
}

return M
