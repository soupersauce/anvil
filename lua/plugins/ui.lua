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
	{ -- barbecue
		'utilyre/barbecue.nvim',
		name = 'barbecue',
		cond = vim.g.started_by_firenvim == nil,
		version = '*',
		dependencies = {
			'SmiteshP/nvim-navic',
			'nvim-tree/nvim-web-devicons', -- optional dependency
		},
		opts = {
			-- configurations go here
		},
	},
	{ -- STATUSCOL
		'luukvbaal/statuscol.nvim',
		config = function()
			local builtin = require('statuscol.builtin')
			require('statuscol').setup {
				-- foldfunc = 'builtin',
				thousands = true,
				setopt = true,
				-- order = 'NFS',
				relculright = true,
				segments = {
					{ text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
					{
						sign = { name = { 'Diagnostic' }, maxwidth = 2, auto = true },
						click = 'v:lua.ScSa',
					},
					{ text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
					{
						sign = { name = { '.*' }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
						click = 'v:lua.ScSa',
					},
				},
			}
		end,
	},
	{ -- WINDOWS
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
	{
		'willothy/nvim-cokeline',
		lazy = false,
		keys = {
			{
				',b',
				function()
					require('cokeline.mappings').pick('focus')
				end,
				'cokeline pick buffer',
			},
			{
				',bd',
				function()
					require('cokeline.mappings').pick('close')
				end,
				'cokeline close buffer',
			},
		},
		dependencies = {
			'nvim-lua/plenary.nvim', -- Required for v0.4.0+
			'nvim-tree/nvim-web-devicons', -- If you want devicons
		},
		config = function()
			local is_picking_focus = require('cokeline.mappings').is_picking_focus
			local is_picking_close = require('cokeline.mappings').is_picking_close
			local get_hex = require('cokeline.hlgroups').get_hl_attr

			local red = vim.g.terminal_color_1
			local green = vim.g.terminal_color_2
			local yellow = vim.g.terminal_color_3

			require('cokeline').setup {
				default_hl = {
					fg = function(buffer)
						return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('Comment', 'fg')
					end,
					bg = function()
						return get_hex('ColorColumn', 'bg')
					end,
				},

				components = {
					-- {
					-- 	text = function(buffer)
					-- 		return (buffer.index ~= 1) and '▏' or ''
					-- 	end,
					-- },
					{
						text = '｜',
						fg = function(buffer)
							return buffer.is_modified and yellow or green
						end,
					},
					-- {
					-- 	text = '  ',
					-- },
					{
						text = function(buffer)
							return (is_picking_focus() or is_picking_close()) and buffer.pick_letter .. ' '
								or buffer.devicon.icon
						end,
						fg = function(buffer)
							return (is_picking_focus() and yellow)
								or (is_picking_close() and red)
								or buffer.devicon.color
						end,
						italic = function()
							return (is_picking_focus() or is_picking_close())
						end,
						bold = function()
							return (is_picking_focus() or is_picking_close())
						end,
					},
					{
						text = ' ',
					},
					{
						text = function(buffer)
							return buffer.index .. ': '
						end,
					},
					{
						text = function(buffer)
							return buffer.unique_prefix
						end,
						fg = get_hex('Comment', 'fg'),
						italic = true,
					},
					{
						text = function(buffer)
							return buffer.filename .. '  '
						end,
						bold = function(buffer)
							return buffer.is_focused
						end,
					},
					{
						text = function(buffer)
							if buffer.is_modified then
								return ''
							end
							if buffer.is_hovered then
								return '󰅙'
							end
							return '󰅖'
						end,

						fg = function(buffer)
							if buffer.is_modified then
								return get_hex('Label', 'fg')
							end
						end,
						on_click = function(_, _, _, _, buffer)
							buffer:delete()
						end,
					},
					{
						text = ' ',
					},
					-- {
					-- 	text = '',
					-- 	on_click = function(buffer)
					-- 		buffer:delete()
					-- 	end,
					-- },
					-- {
					-- 	text = '  ',
					-- },
				},
			}
		end,
	},
	-- { -- BUFFERLINE:
	-- 	'akinsho/bufferline.nvim',
	-- 	cond = vim.g.started_by_firenvim == nil,
	-- 	dependencies = 'nvim-tree/nvim-web-devicons',
	-- 	event = 'BufAdd',
	-- 	opts = {
	-- 		options = {
	-- 			{ filetype = 'NvimTree', text = '', padding = 1 },
	-- 			buffer_close_icon = '',
	-- 			show_close_icon = false,
	-- 			left_trunc_marker = ' ',
	-- 			right_trunc_marker = ' ',
	-- 			max_name_length = 20,
	-- 			max_prefix_length = 13,
	-- 			tab_size = 20,
	-- 			show_tab_indicators = true,
	-- 			enforce_regular_tabs = false,
	-- 			show_buffer_close_icons = false,
	-- 			separator_style = 'thin',
	-- 			themable = true,
	-- 		},
	-- 	},
	-- },
	-- NUI:
	'MunifTanjim/nui.nvim',
}

return M
