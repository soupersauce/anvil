local M = {
	{
		'uga-rosa/ccc.nvim',
		opts = {
			highlighter = {
				auto_enable = true,
			},
		},
	},
	'sitiom/nvim-numbertoggle',
	{ -- tint.nvim
		'levouh/tint.nvim',
		config = true,
	},
	{ -- DRESSING:
		'stevearc/dressing.nvim',
		cond = vim.g.started_by_firenvim == nil,
		event = 'VeryLazy',
		config = function()
			local dressing = require('dressing')

			dressing.setup {
				select = {
					backend = { 'fzf_lua', 'fzf', 'nui', 'telescope', 'builtin' },
				},
			}
		end,
	},
	{ -- TRANSPARENT:
		'xiyaowong/nvim-transparent',
		config = true,
	},
	{ -- NOTIFY:
		'rcarriga/nvim-notify',
		cond = vim.g.started_by_firenvim == nil,
		config = {
			render = 'compact',
		},
	},
	-- floating winbar
	{
		'b0o/incline.nvim',
		event = 'BufReadPre',
		cond = vim.g.started_by_firenvim == nil,
		config = function()
			require('incline').setup {
				-- local colors = require('kanagawa.colors').setup()

				debounce_threshold = { falling = 500, rising = 250 },
				render = function(props)
					local bufname = vim.api.nvim_buf_get_name(props.buf)
					local filename = vim.fn.fnamemodify(bufname, ':t')
					-- local diagnostics = get_diagnostic_label(props)
					local modified = vim.api.nvim_buf_get_option(props.buf, 'modified') and 'bold,italic' or 'None'
					local filetype_icon, color = require('nvim-web-devicons').get_icon_color(filename)
					if vim.api.nvim_buf_get_option(props.buf, 'modified') then
						color = 'red'
					end

					local buffer = {
						{ filetype_icon, guifg = color },
						{ ' ' },
						{ filename, gui = modified },
					}
					return buffer
				end,
				-- highlight = {
				-- 	groups = {
				-- 		InclineNormal = { guibg = '#658594', guifg = colors.black },
				-- 		InclineNormalNC = { guifg = '#658594', guibg = colors.black },
				-- 	},
				-- },
				window = { margin = { vertical = 0, horizontal = 1 } },
			}
		end,
	},
	{
		'anuvyklack/windows.nvim',
		cond = vim.g.started_by_firenvim == nil,
		event = 'WinNew',
		dependencies = {
			{ 'anuvyklack/middleclass' },
			{ 'anuvyklack/animation.nvim', enabled = false },
		},
		keys = { { '<leader>Z', '<cmd>WindowsMaximize<cr>', desc = 'Zoom' } },
		config = function()
			vim.o.winwidth = 5
			vim.o.equalalways = false
			require('windows').setup {
				-- animation = { enable = false, duration = 150 },
			}
		end,
	},
	{ -- BUFFERLINE:
		'akinsho/bufferline.nvim',
		cond = vim.g.started_by_firenvim == nil,
		dependencies = 'kyazdani42/nvim-web-devicons',
		event = 'BufAdd',
		opts = {
			options = {
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
				show_buffer_close_icons = false,
				separator_style = 'thin',
				themable = true,

				-- top right buttons in bufferline
				-- custom_areas = {
				-- 	right = function()
				-- 		return {
				-- 			{ text = '%@Toggle_theme@' .. vim.g.toggle_theme_icon .. '%X' },
				-- 			{ text = '%@Quit_vim@ %X' },
				-- 		}
				-- 	end,
				-- },
			},
		},
	},
	-- NUI:
	'MunifTanjim/nui.nvim',
}

return M
