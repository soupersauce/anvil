local icons_ok, eicons = pcall(require, 'icons')
local present, nvimtree = pcall(require, 'nvim-tree')
if not icons_ok then
	eicons = {}
end

if not present then
	return
end

nvimtree.setup {
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
		width = 25,
		hide_root_folder = true,
	},
	git = {
		enable = true,
		ignore = true,
	},
	actions = {
		open_file = {
			resize_window = true,
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
			glyphs = eicons.glyphs,
		},
	},
}
