local M = {
	{ -- neogit
		'TimUntersberger/neogit',
		cmd = 'Neogit',
		dependencies = {
			'nvim-lua/plenary.nvim', -- required
			'nvim-telescope/telescope.nvim', -- optional
			'sindrets/diffview.nvim', -- optional
			'ibhagwan/fzf-lua', -- optional
		},
		cond = vim.g.started_by_firenvim == nil,
		opts = {
			signs = {
				section = { '▶', '▼' },
				item = { '┗', '┣' },
				hunk = { '┃', '━' },
			},
		},
	},
	{
		'aaronhallaert/advanced-git-search.nvim',
		config = function()
			require('advanced_git_search.fzf').setup {
				-- Insert Config here
			}
		end,
		dependencies = {
			'nvim-telescope/telescope.nvim',
			-- to show diff splits and open commits in browser
			'tpope/vim-fugitive',
			-- to open commits in browser with fugitive
			'tpope/vim-rhubarb',
			-- optional: to replace the diff from fugitive with diffview.nvim
			-- (fugitive is still needed to open in browser)
			'sindrets/diffview.nvim',
		},
	},
	{ -- gitsigns
		'lewis6991/gitsigns.nvim',
		cond = vim.g.started_by_firenvim == nil,
		opts = {
			on_attach = function()
				local set_keymap = function(lhs, rhs, desc)
					vim.keymap.set('n', lhs, rhs, { noremap = true, desc = desc })
				end
				local gitsigns = require('gitsigns')
				set_keymap('<leader>gs', gitsigns.stage_hunk, 'gitsigns.stage_hunk')
				set_keymap('<leader>gu', gitsigns.undo_stage_hunk, 'gitsigns.undo_stage_hunk')
				set_keymap('[g', function()
					gitsigns.nav_hunk('prev')
				end, 'gitsigns.prev_hunk')
				set_keymap(']g', function()
					gitsigns.nav_hunk('next')
				end, 'gitsigns.next_hunk')
				set_keymap('<leader>g', gitsigns.preview_hunk, 'gitsigns.preview_hunk')
			end,
			sign_priority = 10,
			update_debounce = 100,
			status_formatter = nil,
			max_file_length = 40000,
			current_line_blame_formatter = '      <author>, <author_time:%R> - <summary>',
			signcolumn = true,
			numhl = true,
			linehl = false,
			word_diff = true,
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol',
				delay = 1000,
				ignore_whitespace = true,
			},
			preview_config = {
				-- Options passed to nvim_open_win
				border = 'single',
				style = 'minimal',
				relative = 'cursor',
				row = 0,
				col = 1,
			},
		},
	},
	{ -- diffview
		'sindrets/diffview.nvim',
		cond = vim.g.started_by_firenvim == nil,
		keys = {
			{
				',gD',
				function()
					require('diffview').open()
				end,
				desc = 'Open diffview',
			},
		},
		config = function(opts)
			local actions = require('diffview.actions')
			local diffview = require('diffview')
			opts =
				opts or {
					diff_binaries = false, -- Show diffs for binaries
					enhanced_diff_hl = false, -- See |diffview-config-enhanced_diff_hl|
					git_cmd = { 'git' }, -- The git executable followed by default args.
					use_icons = true, -- Requires nvim-web-devicons
					icons = { -- Only applies when use_icons is true.
						folder_closed = '',
						folder_open = '',
					},
					signs = {
						fold_closed = '▶',
						fold_open = '▼',
					},
					file_panel = {
						listing_style = 'list', -- One of 'list' or 'tree'
						tree_options = { -- Only applies when listing_style is 'tree'
							flatten_dirs = true, -- Flatten dirs that only contain one single dir
							folder_statuses = 'only_folded', -- One of 'never', 'only_folded' or 'always'.
						},
						win_config = { -- See |diffview-config-win_config|
							position = 'left',
							width = 30,
						},
					},
					file_history_panel = {
						-- log_options = { -- See |diffview-config-log_options|
						-- 	single_file = {
						-- 		diff_merges = 'combined',
						-- 	},
						-- 	multi_file = {
						-- 		diff_merges = 'first-parent',
						-- 	},
						-- },
						win_config = { -- See |diffview-config-win_config|
							position = 'bottom',
							height = 16,
						},
					},
					commit_log_panel = {
						win_config = {}, -- See |diffview-config-win_config|
					},
					default_args = { -- Default args prepended to the arg-list for the listed commands
						DiffviewOpen = {},
						DiffviewFileHistory = {},
					},
					hooks = {}, -- See |diffview-config-hooks|
					keymaps = {
						disable_defaults = true, -- Disable the default keymaps
						view = {
							-- The `view` bindings are active in the diff buffers, only when the current
							-- tabpage is a Diffview.
							['<tab>'] = actions.select_next_entry, -- Open the diff for the next file
							['<s-tab>'] = actions.select_prev_entry, -- Open the diff for the previous file
							['gf'] = actions.goto_file, -- Open the file in a new split in previous tabpage
							['<C-w><C-f>'] = actions.goto_file_split, -- Open the file in a new split
							['<C-w>gf'] = actions.goto_file_tab, -- Open the file in a new tabpage
							['<leader>e'] = actions.focus_files, -- Bring focus to the files panel
							['<leader>b'] = actions.toggle_files, -- Toggle the files panel.
							['q'] = diffview.close, -- Close DiffView
						},
						file_panel = {
							['j'] = actions.next_entry, -- Bring the cursor to the next file entry
							['<down>'] = actions.next_entry,
							['k'] = actions.prev_entry, -- Bring the cursor to the previous file entry.
							['<up>'] = actions.prev_entry,
							['<cr>'] = actions.select_entry, -- Open the diff for the selected entry.
							['o'] = actions.select_entry,
							['<2-LeftMouse>'] = actions.select_entry,
							['-'] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
							['S'] = actions.stage_all, -- Stage all entries.
							['U'] = actions.unstage_all, -- Unstage all entries.
							['X'] = actions.restore_entry, -- Restore entry to the state on the left side.
							['R'] = actions.refresh_files, -- Update stats and entries in the file list.
							['L'] = actions.open_commit_log, -- Open the commit log panel.
							['<c-b>'] = actions.scroll_view(-0.25), -- Scroll the view up
							['<c-f>'] = actions.scroll_view(0.25), -- Scroll the view down
							['<tab>'] = actions.select_next_entry,
							['<s-tab>'] = actions.select_prev_entry,
							['gf'] = actions.goto_file,
							['<C-w><C-f>'] = actions.goto_file_split,
							['<C-w>gf'] = actions.goto_file_tab,
							['i'] = actions.listing_style, -- Toggle between 'list' and 'tree' views
							['f'] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.
							['<leader>e'] = actions.focus_files,
							['<leader>b'] = actions.toggle_files,
							['q'] = diffview.close,
						},
						file_history_panel = {
							['g!'] = actions.options, -- Open the option panel
							['<C-A-d>'] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
							['y'] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
							['L'] = actions.open_commit_log,
							['zR'] = actions.open_all_folds,
							['zM'] = actions.close_all_folds,
							['j'] = actions.next_entry,
							['<down>'] = actions.next_entry,
							['k'] = actions.prev_entry,
							['<up>'] = actions.prev_entry,
							['<cr>'] = actions.select_entry,
							['o'] = actions.select_entry,
							['<2-LeftMouse>'] = actions.select_entry,
							['<c-b>'] = actions.scroll_view(-0.25),
							['<c-f>'] = actions.scroll_view(0.25),
							['<tab>'] = actions.select_next_entry,
							['<s-tab>'] = actions.select_prev_entry,
							['gf'] = actions.goto_file,
							['<C-w><C-f>'] = actions.goto_file_split,
							['<C-w>gf'] = actions.goto_file_tab,
							['<leader>e'] = actions.focus_files,
							['<leader>b'] = actions.toggle_files,
							['q'] = diffview.close,
						},
						option_panel = {
							['<tab>'] = actions.select_entry,
							['q'] = actions.close,
						},
					},
				}, diffview.setup(opts)
		end,
	},
}
-- Gitsigns configuration
return M
