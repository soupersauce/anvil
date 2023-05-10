local M = {
	{ -- urlview
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
	{ -- which-key
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
	{ -- hlslens
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
	{ -- marks
		'chentoast/marks.nvim',
		config = true,
	},
	{ -- various_textobjs
		'chrisgrieser/nvim-various-textobjs',
		opts = { useDefaultKeymaps = true },
	},
	{ -- tridactyl
		'tridactyl/vim-tridactyl', -- for tridactyl firefox plugin
		event = 'bufReadPre tridactylrc',
		config = function()
			vim.api.nvim_create_autocmd({ 'bufRead' }, {
				pattern = 'tridactylrc',
				command = 'set ft=tridactylrc',
			})
		end,
	},
	{ -- nvim spider w, e ,b motions
		'chrisgrieser/nvim-spider',
		lazy = true,
		keys = {
			{ 'w', "<cmd>lua require('spider').motion('w')<CR>", { desc = 'Spider-w' } },
			{ 'e', "<cmd>lua require('spider').motion('e')<CR>", { desc = 'Spider-w' } },
			{ 'b', "<cmd>lua require('spider').motion('b')<CR>", { desc = 'Spider-w' } },
			{ 'ge', "<cmd>lua require('spider').motion('ge')<CR>", { desc = 'Spider-w' } },
		},
	},
	{
		'mrjones2014/smart-splits.nvim',
		config = true,
		keys = {
			-- moving between splits
			{
				'<A-h>',
				function()
					require('smart-splits').move_cursor_left()
				end,
				desc = 'smart-splits move left',
			},
			{
				'<A-j>',
				function()
					require('smart-splits').move_cursor_down()
				end,
				desc = 'smart-splits move left',
			},
			{
				'<A-k>',
				function()
					require('smart-splits').move_cursor_up()
				end,
				desc = 'smart-splits move left',
			},
			{
				'<A-l>',
				function()
					require('smart-splits').move_cursor_right()
				end,
				desc = 'smart-splits move left',
			},
		},
	},
}
return M
