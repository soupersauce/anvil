local M = { -- TREESITTER; integration
	'RRethy/vim-illuminate',
	{ -- regex explainer
		'bennypowers/nvim-regexplainer',
		config = true,
	},
	{ -- TREESITTER
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			-- nvim-treesitter configuration
			local config = require('nvim-treesitter.configs')
			-- require('orgmode').setup_ts_grammar()

			config.setup {
				ensure_installed = {
					'dockerfile',
					'json',
					'lua',
					'python',
					'regex',
					'yaml',
					'markdown',
					'markdown_inline',
					'bash',
					'comment',
					'llvm',
					'todotxt',
					'toml',
					'org',
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { 'org', 'typescript' },
					use_languagetree = true,
				},
				playground = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = 'gs',
						node_decremental = '<C-j>',
						node_incremental = '<C-k>',
						scope_incremental = 'gss',
					},
				},
				-- context_commentstring = {
				-- 	enable = true,
				-- 	enable_autocmd = false,
				-- },
				indent = {
					enable = true,
				},
				matchup = {
					enable = true,
				},
				autopairs = {
					enable = true,
				},
				pairs = {
					enable = true,
				},
				textobjects = {
					selected = {
						enable = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ac'] = '@class.outer',
							['ic'] = '@class.inner',
						},
						-- You can choose the select mode (default is charwise 'v')
						selection_modes = {
							['@parameter.outer'] = 'v', -- charwise
							['@function.outer'] = 'V', -- linewise
							['@class.outer'] = '<c-v>', -- blockwise
						},
						-- If you set this to `true` (default is `false`) then any textobject is
						-- extended to include preceding xor succeeding whitespace. Succeeding
						-- whitespace has priority in order to act similarly to eg the built-in
						-- `ap`.
					},
					swap = {
						enable = true,
						swap_next = {
							['<leader>a'] = '@parameter.inner',
						},
						swap_previous = {
							['<leader>A'] = '@parameter.inner',
						},
						move = {
							enable = true,
							set_jumps = true, -- whether to set jumps in the jumplist
							goto_next_start = {
								[']m'] = '@function.outer',
								[']]'] = '@class.outer',
							},
							goto_next_end = {
								[']M'] = '@function.outer',
								[']['] = '@class.outer',
							},
							goto_previous_start = {
								['[m'] = '@function.outer',
								['[['] = '@class.outer',
							},
							goto_previous_end = {
								['[M'] = '@function.outer',
								['[]'] = '@class.outer',
							},
						},
					},
				},
				sync_install = false,
			}
			-- require "nvim-treesitter.highlight"
			-- local hlmap = vim.treesitter.highlighter.hl_map
			-- hlmap["punctuation.bracket"] = nil
		end,
	-- },
	-- 'joosepalviste/nvim-ts-context-commentstring',
	-- {
		'hiphish/rainbow-delimiters.nvim',
		-- branch = 'use-children',
		dependencies = 'nvim-treesitter/nvim-treesitter',
		config = function()
			-- This module contains a number of default definitions
			local rainbow_delimiters = require('rainbow-delimiters')

			vim.g.rainbow_delimiters = {
				strategy = {
					[''] = rainbow_delimiters.strategy['global'],
					vim = rainbow_delimiters.strategy['local'],
				},
				query = {
					[''] = 'rainbow-delimiters',
					lua = 'rainbow-blocks',
				},
				highlight = {
					'RainbowDelimiterRed',
					'RainbowDelimiterYellow',
					'RainbowDelimiterBlue',
					'RainbowDelimiterOrange',
					'RainbowDelimiterGreen',
					'RainbowDelimiterViolet',
					'RainbowDelimiterCyan',
				},
			}
		end,
	},
	'nvim-treesitter/nvim-treesitter-textobjects',
	{ -- TODO COMMENTS
		'folke/todo-comments.nvim',
		opts = {
			highlight = {
				exclude = { 'vim', 'packer', 'NeogitStatus', 'NeogitPopup', 'nofile', 'terminal' },
			},
		},
	},
	{ 'kevinhwang91/nvim-bqf', ft = 'qf' },
	'andymass/vim-matchup',
	'nvim-treesitter/playground',
	'nvim-treesitter/nvim-treesitter-context',
	{ -- syntax-tree-surfer
		'ziontee113/syntax-tree-surfer',
		config = true,
	},
	'mizlan/iswap.nvim',
	{ -- REFACTORING
		'ThePrimeagen/refactoring.nvim',
		config = true,
	},
}
return M
