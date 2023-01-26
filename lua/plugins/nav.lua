local M = {
	{
		'axieax/urlview.nvim',
		cmd = 'UrlView',
		keys = {
			{ '<leader>L', '<cmd>UrlView<CR>', { desc = 'Buffer URLs' } },
			{ '<leader>ll', '<cmd>UrlView lazy<CR>', { desc = 'Lazy URLs' } },
		},
		opts = {
			default_action = 'system',
			sorted = 'false',
		},
	},
	{
		'folke/which-key.nvim',
		cond = vim.g.started_by_firenvim == nil,
		opts = {

			popup_mappings = {
				scroll_down = '<c-d>', -- binding to scroll down inside the popup
				scroll_up = '<c-u>', -- binding to scroll up inside the popup
			},
			--
			window = {
				border = 'none', -- none/single/double/shadow
			},

			layout = {
				spacing = 1, -- spacing between columns
			},

			hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' },

			triggers_blacklist = {
				-- list of mode / prefixes that should never be hooked by WhichKey
				i = { 'j', 'k' },
				v = { 'j', 'k' },
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
	{ -- scrollbar
		'petertriho/nvim-scrollbar',
		cond = vim.g.started_by_firenvim == nil,
		opts = {
			handlers = {
				diagnostic = true,
				search = true, -- Requires hlslens to be loaded
				gitsigns = true, -- Requires gitsigns.nvim
			},
		},
	},
	{
		'chentoast/marks.nvim',
		config = true,
	},
	{ -- VARIOUS_TEXTOBJS:
		'chrisgrieser/nvim-various-textobjs',
		opts = { useDefaultKeymaps = true },
	},
	{
		'tridactyl/vim-tridactyl', -- for tridactyl firefox plugin
		event = 'bufReadPre tridactylrc',
		config = function()
			vim.api.nvim_create_autocmd({ 'bufRead' }, {
				pattern = 'tridactylrc',
				command = 'set ft=tridactylrc',
			})
		end,
	},
}
return M
