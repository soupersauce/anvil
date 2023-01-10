local M = {
	{ -- DRESSING:
		'stevearc/dressing.nvim',
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
	{ -- BLANKLINE:
		'lukas-reineke/indent-blankline.nvim',
		init = function()
			vim.opt.list = true
			vim.opt.listchars:append('space:⋅')
			vim.opt.listchars:append('multispace: ')
			vim.opt.listchars:append('lead: ')
			vim.opt.listchars:append('eol:↴')
		end,
		opts = {
			indentLine_enabled = true,
			char = '▏',
			filetype_exclude = {
				'help',
				'terminal',
				'alpha',
				'packer',
				'lspinfo',
				'TelescopePrompt',
				'TelescopeResults',
				'lsp-installer',
				'undotree',
				'NeogitStatus',
				'NeogitCommitMessage',
				'NeogitPopup',
				'lazy',
				'',
			},
			buftype_exclude = { 'terminal' },
			space_char_blankeline = ' ',
			show_trailing_blankline_indent = false,
			show_first_indent_level = false,
			show_current_context = true,
			show_current_context_start = true,
		},
	},
	{ -- TRANSPARENT:
		'xiyaowong/nvim-transparent',
		config = true,
	},
	{ -- NOTIFY:
		'rcarriga/nvim-notify',
		config = true,
	},
	-- floating winbar
	{
		'b0o/incline.nvim',
		event = 'BufReadPre',
		config = function()
			local colors = require('kanagawa.colors').setup()
			require('incline').setup {
				highlight = {
					groups = {
						InclineNormal = { guibg = '#658594', guifg = colors.black },
						InclineNormalNC = { guifg = '#658594', guibg = colors.black },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
					local icon, color = require('nvim-web-devicons').get_icon_color(filename)
					return { { icon, guifg = color }, { ' ' }, { filename } }
				end,
			}
		end,
	},
	{
		'anuvyklack/windows.nvim',
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
	{ -- HLSLENS:
		'kevinhwang91/nvim-hlslens',
		config = function()
			local vim = vim
			require('hlslens').setup {
				build_position_cb = function(plist, _, _, _)
					require('scrollbar.handlers.search').handler.show(plist.start_pos)
				end,
			}
			local kopts = { noremap = true, silent = true }

			vim.keymap.set(
				'n',
				'n',
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.keymap.set(
				'n',
				'N',
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

			vim.cmd([[
            augroup scrollbar_search_hide
                autocmd!
                autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
            augroup END
        ]])
		end,
	},
	{ -- UFO:
		'kevinhwang91/nvim-ufo',
		dependencies = 'kevinhwang91/promise-async',
		keys = {
			{
				'zR',
				function()
					require('ufo').openAllFolds()
				end,
				desc = 'UfoOpenAll',
			},
			{
				'zM',
				function()
					require('ufo').closeAllFolds()
				end,
				desc = 'UfoCloseAll',
			},
			{
				'zr',
				function()
					require('ufo').openFoldsExceptKinds()
				end,
				desc = 'UfoOpenExcept',
			},
			{
				'zm',
				function()
					require('ufo').closeFoldsWith()
				end,
				desc = 'UfoCloseWith',
			}, -- closeAllFolds == closeFoldsWith(0)
		},
		config = function()
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ('  %d '):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, 'MoreMsg' })
				return newVirtText
			end

			-- If you disable this autocmd and some folds in org files won't close
			-- This is why. TODO: see if we can make it work?
			vim.api.nvim_create_autocmd({ 'FileType' }, {
				pattern = { 'org' },
				callback = function()
					require('ufo').detach()
				end,
			})

			require('ufo').setup {
				provider_selector = function(bufnr, filetype, buftype)
					return { 'lsp', 'indent' }
				end,
				fold_virt_text_handler = handler,
			}
		end,
	},
	{ -- WEB-DEVICONS:
		'kyazdani42/nvim-web-devicons',
		opts = { default = true },
	},
	-- LSPKIND:
	'onsails/lspkind.nvim',
	-- NUI:
	'MunifTanjim/nui.nvim',
}

return M
