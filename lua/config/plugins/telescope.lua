local M = { -- TELESCOPE
		'nvim-telescope/telescope.nvim',
    cmd = { 'Telescope' },
		dependencies = {
			'kyazdani42/nvim-web-devicons',
		},
    -- keys = {'<leader>u','lua require("telescope").extensions.undo.undo()', desc = 'Telescope Undo'}
}

function M.config()
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
      undo = {

      },
		},
	}

	telescope.load_extension('fzf')
	telescope.load_extension('undo')
	-- telescope.load_extension('dap')

  -- vim.keymap.set("n", "<leader>u",'lua require("telescope").extensions.undo.undo()', desc = "Telescope Undo")
	-- vim.keymap.set('<leader>ff', telescope_builtin.find_files)
	-- vim.keymap.set('<leader>fb', telescope_builtin.buffers)
	-- vim.keymap.set('<leader>fc', telescope_builtin.commands)
	-- vim.keymap.set('<leader>fq', telescope_builtin.quickfix)
	-- vim.keymap.set('<leader>fg', telescope_builtin.git_status)
	-- vim.keymap.set('<leader>fl', telescope_builtin.loclist)
	-- vim.keymap.set('<F1>', telescope_builtin.help_tags)

	-- vim.keymap.set('<leader>f', telescope.extensions.live_grep_args.live_grep_args)

	-- local dap = telescope.extensions.dap
	-- vim.keymap.set('<leader>do', dap.commands)
	-- vim.keymap.set('<leader>dc', dap.configurations)
	-- vim.keymap.set('<leader>db', dap.list_breakpoints)
	-- vim.keymap.set('<leader>dv', dap.variables)
	-- vim.keymap.set('<leader>df', dap.frames)
end

function M.init()
  vim.keymap.set("n", "<leader>u",function() require("telescope").extensions.undo.undo() end, {desc = "Telescope Undo"})
end

return M
