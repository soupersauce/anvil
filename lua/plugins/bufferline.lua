local present, bufferline = pcall(require, 'bufferline')

if not present then
	return
end

bufferline.setup {
	{ filetype = 'NvimTree', text = '', padding = 1 },
	buffer_close_icon = '',
	show_close_icon = false,
	left_trunc_marker = ' ',
	right_trunc_marker = ' ',
	max_name_length = 20,
	max_prefix_length = 13,
	tab_size = 20,
	show_tab_indicators = true,
	enforce_regular_tabs = false,
	show_buffer_close_icons = true,
	separator_style = 'thin',
	themable = true,

	-- top right buttons in bufferline
	custom_areas = {
		right = function()
			return {
				{ text = '%@Toggle_theme@' .. vim.g.toggle_theme_icon .. '%X' },
				{ text = '%@Quit_vim@ %X' },
			}
		end,
	},
}

-- check for any override
-- options = require("core.utils").load_override(options, "akinsho/bufferline.nvim")
