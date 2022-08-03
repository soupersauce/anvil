-- Telescope configuration
local map = vim.keymap.set
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
	},
}

telescope.load_extension('fzf')
-- telescope.load_extension('dap')

local set_keymap = function(lhs, rhs)
	map('n', lhs, rhs, { noremap = true })
end

set_keymap('<leader>ff', telescope_builtin.find_files)
set_keymap('<leader>fb', telescope_builtin.buffers)
set_keymap('<leader>fc', telescope_builtin.commands)
set_keymap('<leader>fq', telescope_builtin.quickfix)
set_keymap('<leader>fg', telescope_builtin.git_status)
set_keymap('<leader>fl', telescope_builtin.loclist)
set_keymap('<F1>', telescope_builtin.help_tags)

-- set_keymap('<leader>f', telescope.extensions.live_grep_args.live_grep_args)

-- local dap = telescope.extensions.dap
-- set_keymap('<leader>do', dap.commands)
-- set_keymap('<leader>dc', dap.configurations)
-- set_keymap('<leader>db', dap.list_breakpoints)
-- set_keymap('<leader>dv', dap.variables)
-- set_keymap('<leader>df', dap.frames)
