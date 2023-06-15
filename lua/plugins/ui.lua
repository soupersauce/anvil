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
				foldfunc = 'builtin',
				thousands = true,
				setopt = true,
				order = 'NFS',
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
	{ -- BUFFERLINE:
		'akinsho/bufferline.nvim',
		cond = vim.g.started_by_firenvim == nil,
		dependencies = 'nvim-tree/nvim-web-devicons',
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
			},
		},
	},
	-- NUI:
	'MunifTanjim/nui.nvim',
}

return M
