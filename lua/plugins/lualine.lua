local M = { -- LUALINE
	'nvim-lualine/lualine.nvim',
	cond = vim.g.started_by_firenvim == nil,
}

function M.config()
	local vim = vim
	local lualine = require('lualine')
	local navic = require('nvim-navic')
	local custom_fname = require('lualine.components.filename'):extend()
	local highlight = require('lualine.highlight')
	local default_status_colors = { modified = '#c678dd' }

	-- Color table for highlights
	local colors = {
		bg = '#202328',
		fg = '#bbc2cf',
		yellow = '#ECBE7B',
		cyan = '#008080',
		darkblue = '#081633',
		green = '#98be65',
		orange = '#FF8800',
		violet = '#a9a1e1',
		magenta = '#c678dd',
		blue = '#51afef',
		red = '#ec5f67',
	}

	local modecolors = function()
		-- auto change color according to neovims mode
		local mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			[''] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			[''] = colors.orange,
			ic = colors.yellow,
			R = colors.violet,
			Rv = colors.violet,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			['r?'] = colors.cyan,
			['!'] = colors.red,
			t = colors.red,
		}
		return { fg = mode_color[vim.fn.mode()] }
	end

	function custom_fname:init(options)
		custom_fname.super.init(self, options)
		self.status_colors = {
			saved = highlight.create_component_highlight_group(
				{ bg = default_status_colors.saved },
				'filename_status_saved',
				self.options
			),
			modified = highlight.create_component_highlight_group(
				{ bg = colors.fg, fg = colors.bg },
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

	local conditions = {
		buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
		end,
		hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end,
		check_git_workspace = function()
			local filepath = vim.fn.expand('%:p:h')
			local gitdir = vim.fn.finddir('.git', filepath .. ';')
			return gitdir and #gitdir > 0 and #gitdir < #filepath
		end,
	}

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

	local function icon_by_ft()
		local ft = vim.filetype.match { buf = vim.api.nvim_get_current_buf() }
		return require('nvim-web-devicons').get_icon_by_filetype(ft)
	end

	local evil = function()
		-- Config
		local config = {
			options = {
				-- Disable sections and component separators
				component_separators = '',
				section_separators = '',
				theme = {
					-- We are going to use lualine_c an lualine_x as left and
					-- right section. Both are highlighted by c theme .  So we
					-- are just setting default looks o statusline
					normal = { c = { fg = colors.fg, bg = colors.bg } },
					inactive = { c = { fg = colors.fg, bg = colors.bg } },
				},
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {}, --{ custom_fname, { navic.get_location(navic_opts), cond = navic.is_available } },
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x ot right section
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		ins_left {
			function()
				return icon_by_ft()
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = {
					n = colors.red,
					i = colors.green,
					v = colors.blue,
					[''] = colors.blue,
					V = colors.blue,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					[''] = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					['r?'] = colors.cyan,
					['!'] = colors.red,
					t = colors.red,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { left = 0, right = 1 }, -- We don't need space before this
		}

		ins_left {
			-- filesize component
			'filesize',
			cond = conditions.buffer_not_empty,
		}

		ins_left { 'location' }

		ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

		ins_left {
			custom_fname,
			color = { fg = colors.violet, gui = 'bold' },
		}

		ins_left {
			-- function()
			require('NeoComposer.ui').status_recording,
			-- end,
		}

		-- Insert mid section. You can make any number of sections in neovim :)
		-- for lualine it's any number greater then 2
		ins_left {
			function()
				return '%='
			end,
		}

		ins_right {
			'diagnostics',
			sources = { 'nvim_diagnostic' },
			symbols = { error = ' ', warn = ' ', info = ' ' },
			diagnostics_color = {
				color_error = { fg = colors.red },
				color_warn = { fg = colors.yellow },
				color_info = { fg = colors.cyan },
			},
		}

		ins_right {
			-- Lsp server name .
			function()
				local msg = ''
				local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
				local clients = vim.lsp.get_active_clients()
				if next(clients) == nil then
					return msg
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						return client.name
					end
				end
				return msg
			end,
			icon = icon_by_ft(),
			color = { gui = 'bold' },
		}

		-- Add components to right sections
		ins_right {
			'o:encoding', -- option component same as &encoding in viml
			-- fmt = string.upper, -- I'm not sure why it's upper case either ;)
			cond = conditions.hide_in_width,
			color = { fg = colors.green, gui = 'bold' },
		}

		ins_right {
			'fileformat',
			fmt = string.upper,
			icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
			color = { fg = colors.green, gui = 'bold' },
		}

		ins_right {
			'branch',
			icon = '',
			color = { fg = colors.violet, gui = 'bold' },
		}

		ins_right {
			'diff',
			source = diff_source(),
			-- Is it me or the symbol for modified us really weird
			symbols = { added = ' ', modified = '柳 ', removed = ' ' },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.orange },
				removed = { fg = colors.red },
			},
			cond = conditions.hide_in_width,
		}

		ins_right {
			function()
				return icon_by_ft()
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = {
					n = colors.red,
					i = colors.green,
					v = colors.blue,
					[''] = colors.blue,
					V = colors.blue,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					[''] = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					['r?'] = colors.cyan,
					['!'] = colors.red,
					t = colors.red,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { left = 1 },
		}

		-- Now don't forget to initialize lualine
		lualine.setup(config)
	end

	local default = function()
		lualine.setup {
			options = {
				icons_enabled = true,
				theme = 'auto',
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
				disabled_filetypes = {},
				always_divide_middle = true,
				globalstatus = false,
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { { 'b:gitsigns_head', icon = '' }, { 'diff', source = diff_source() }, 'diagnostics' },
				-- lualine_c = { custom_fname, { navic.get_location, cond = navic.is_available } },
				lualine_c = { { navic.get_location, cond = navic.is_available } },
				lualine_x = {},
				lualine_y = {},
				lualine_z = { 'encoding', 'fileformat', 'filetype', 'progress', 'location' },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				-- lualine_c = { 'filename' },
				-- lualine_x = { 'location' },
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
			winbar = {
				lualine_c = { 'filename' },
			},
			inactive_winbar = {
				lualine_c = { 'filename' },
			},
		}
	end
	evil()
end

return M
