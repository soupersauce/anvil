local M = {
	{
		'kyazdani42/nvim-tree.lua',
		dependencies = {
			'kyazdani42/nvim-web-devicons',
		},
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
		config = true,
	},
}

return M
