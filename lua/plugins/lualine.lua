local lualine_ok, lualine = pcall(require, 'lualine')
if not lualine_ok then
	return
end

local navic_ok, navic = pcall(require, 'nvim-navic')

-- Uses gitsigns as the source for diff info
local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.modified,
			removed = gitsigns.removed,
		}
	end
end

local custom_fname = require('lualine.components.filename'):extend()
local highlight = require('lualine.highlight')
local default_status_colors = { modified = '#C70039' }

function custom_fname:init(options)
	custom_fname.super.init(self, options)
	self.status_colors = {
		saved = highlight.create_component_highlight_group(
			{ bg = default_status_colors.saved },
			'filename_status_saved',
			self.options
		),
		modified = highlight.create_component_highlight_group(
			{ bg = default_status_colors.modified },
			'filename_status_modified',
			self.options
		),
	}
	if self.options.color == nil then
		self.options.color = ''
	end
end

function custom_fname:update_status()
	local data = custom_fname.super.update_status(self)
	data = highlight.component_format_highlight(
		vim.bo.modified and self.status_colors.modified or self.status_colors.saved
	) .. data
	return data
end

lualine.setup {
	options = {
		icons_enabled = true,
		theme = 'ayu_dark',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { { 'b:gitsigns_head', icon = '' }, { 'diff', source = diff_source() }, 'diagnostics' },
		lualine_c = { custom_fname, { navic.get_location, cond = navic.is_available } },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {
		'quickfix',
		'fzf',
		'man',
		'nvim-dap-ui',
		'nvim-tree',
		'toggleterm',
		'fugitive',
	},
	-- winbar = {
	-- 	lualine_c = { 'filename' },
	-- },
	-- inactive_winbar = {
	-- 	lualine_c = { 'filename' },
	-- },
}
