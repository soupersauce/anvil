local M = {
	'goolord/alpha-nvim',
	enabled = true,
	cond = vim.g.started_by_firenvim == nil,
	dependencies = 'nvim-lua/plenary.nvim',
}

function M.config()
	local dashboard = require('alpha.themes.dashboard')
	local cdir = vim.fn.getcwd()
	local if_nil = vim.F.if_nil
	local nwd = require('nvim-web-devicons')
	local plenary_path = require('plenary.path')

	local function get_extension(fn)
		local match = fn:match('^.+(%..+)$')
		local ext = ''
		if match ~= nil then
			ext = match:sub(2)
		end
		return ext
	end

	local function icon(fn)
		local ext = get_extension(fn)
		return nwd.get_icon(fn, ext, { default = true })
	end

	local function file_button(fn, sc, short_fn)
		short_fn = short_fn or fn
		local ico_txt
		local fb_hl = {}

		if nwd.enabled then
			local ico, hl = icon(fn)
			local hl_option_type = type(nwd.highlight)
			if hl_option_type == 'boolean' then
				if hl and nwd.highlight then
					table.insert(fb_hl, { hl, 0, 3 })
				end
			end
			if hl_option_type == 'string' then
				table.insert(fb_hl, { nwd.highlight, 0, 3 })
			end
			ico_txt = ico .. '  '
		else
			ico_txt = ''
		end
		local file_button_el = dashboard.button(sc, ico_txt .. short_fn, '<cmd>e ' .. fn .. ' <CR>')
		local fn_start = short_fn:match('.*[/\\]')
		if fn_start ~= nil then
			table.insert(fb_hl, { 'Comment', #ico_txt - 2, #fn_start + #ico_txt })
		end
		file_button_el.opts.hl = fb_hl
		return file_button_el
	end

	local default_mru_ignore = { 'gitcommit' }

	local mru_opts = {
		ignore = function(path, ext)
			return (string.find(path, 'COMMIT_EDITMSG')) or (vim.tbl_contains(default_mru_ignore, ext))
		end,
	}

	--- @param start number
	--- @param cwd string optional
	--- @param items_number number optional number of items to generate, default = 10
	local function mru(start, cwd, items_number, opts)
		opts = opts or mru_opts
		items_number = if_nil(items_number, 9)

		local oldfiles = {}
		for _, v in pairs(vim.v.oldfiles) do
			if #oldfiles == items_number then
				break
			end
			local cwd_cond
			if not cwd then
				cwd_cond = true
			else
				cwd_cond = vim.startswith(v, cwd)
			end
			local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
			if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
				oldfiles[#oldfiles + 1] = v
			end
		end
		local target_width = 35

		local tbl = {}
		for i, fn in ipairs(oldfiles) do
			local short_fn
			if cwd then
				short_fn = vim.fn.fnamemodify(fn, ':.')
			else
				short_fn = vim.fn.fnamemodify(fn, ':~')
			end

			if #short_fn > target_width then
				short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
				if #short_fn > target_width then
					short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
				end
			end

			local shortcut = tostring(i + start - 1)

			local file_button_el = file_button(fn, shortcut, short_fn)
			tbl[i] = file_button_el
		end
		return {
			type = 'group',
			val = tbl,
			opts = {},
		}
	end

	local default_header = {
		type = 'text',
		val = {
			[[                               __                ]],
			[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
			[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
			[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
			[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
			[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
		},
		opts = {
			position = 'center',
			hl = 'Type',
			-- wrap = "overflow";
		},
	}

	local session = {
		type = 'group',
		val = {
			-- { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
			{ type = 'padding', val = 1 },
			dashboard.button('0', '  Restore Session', '<cmd>lua require("persistence").load()<CR>'),
		},
		position = 'center',
	}

	local section_mru = {
		type = 'group',
		val = {
			{
				type = 'text',
				val = 'Recent files',
				opts = {
					hl = 'SpecialComment',
					shrink_margin = false,
					position = 'center',
				},
			},
			{ type = 'padding', val = 1 },
			{
				type = 'group',
				val = function()
					return { mru(1, cdir) }
				end,
				opts = { shrink_margin = false },
			},
		},
	}

	local buttons = {
		type = 'group',
		val = {
			{ type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
			{ type = 'padding', val = 1 },
			dashboard.button('e', '  New file', '<cmd>ene<CR>'),
			dashboard.button('f', '  Find file', '<cmd>FzfLua files<CR>'),
			dashboard.button('g', '  Live grep', '<cmd>FzfLua live_grep<CR>'),
			dashboard.button(
				'c',
				'  Configuration',
				'<cmd>cd ~/.config/nvim/ <CR><silent><cmd>!cd ~/.config/nvim/<CR>'
			),
			dashboard.button('l', '  Lazy', '<cmd>Lazy<CR>'),
			dashboard.button('q', '  Quit', '<cmd>qa<CR>'),
		},
		position = 'center',
	}

	local config = {
		layout = {
			{ type = 'padding', val = 2 },
			default_header,
			{ type = 'padding', val = 2 },
			session,
			{ type = 'padding', val = 2 },
			section_mru,
			{ type = 'padding', val = 2 },
			buttons,
		},
		opts = {
			margin = 5,
			setup = function()
				vim.cmd([[
            autocmd alpha_temp DirChanged * lua require('alpha').redraw()
            ]])
			end,
		},
	}

	require('alpha').setup(config)
end

return M
