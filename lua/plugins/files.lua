local M = {
	'mong8se/actually.nvim',
	'ralismark/vim-recover',
	{
		'stevearc/oil.nvim',
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
	{ -- Lastplace: remember last place in file
		'ethanholz/nvim-lastplace',
		cond = vim.g.started_by_firenvim == nil,
		opts = {
			lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help', 'Trouble', 'terminal', 'nvimtree' },
			lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
			lastplace_open_folds = true,
		},
	},
	{
		'folke/persistence.nvim',
		cond = vim.g.started_by_firenvim == nil,
		event = 'BufReadPre', -- this will only start session saving when an actual file was opened
		-- module = "persistence",
		config = true,
	},
	{
		'kyazdani42/nvim-tree.lua',
		dependencies = {
			'kyazdani42/nvim-web-devicons',
		},
		keys = {
			{ '<C-n>', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle NvimTree', mode = 'n' },
		},
		cond = vim.g.started_by_firenvim == nil,
		opts = {
			filters = {
				dotfiles = false,
				custom = { '.*.org_archive' },
			},
			disable_netrw = false,
			hijack_netrw = false,
			open_on_setup = false,
			ignore_ft_on_setup = { 'alpha' },
			hijack_cursor = true,
			hijack_unnamed_buffer_when_opening = false,
			update_cwd = true,
			update_focused_file = {
				enable = true,
				update_cwd = false,
			},
			view = {
				side = 'left',
				adaptive_size = false,
				hide_root_folder = true,
				signcolumn = 'auto',
			},
			git = {
				enable = true,
				ignore = false,
			},
			actions = {
				open_file = {
					resize_window = false,
				},
			},
			renderer = {
				highlight_git = true,
				highlight_opened_files = 'none',

				indent_markers = {
					enable = true,
				},

				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
				},
			},
		},
	},
	{
		'antosha417/nvim-lsp-file-operations',
		cmd = 'NvimTreeToggle',
		config = true,
	},
}

return M
