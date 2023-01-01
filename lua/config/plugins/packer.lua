local M = {}
-- PLUGIN SETTINGS
-- Configure plugins, plugin specific functions and autocommands are to be
-- written in the corresponding files (makes debugging and trying out plugins easier)
-- local vim = vim
function M.packer()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	local run_sync = false

	-- Install packer for package management, if missing
	---@diagnostic disable-next-line: missing-parameter
	if fn.empty(fn.glob(install_path)) > 0 then
		run_sync = fn.system {
			'git',
			'clone',
			'--depth',
			'1',
			'https://github.com/wbthomason/packer.nvim',
			install_path,
		}
		vim.cmd('packadd packer.nvim')
	end

	-- Use a protected call to avoid errors on first use
	local status_ok, packer = pcall(require, 'packer')
	if not status_ok then
		vim.notify('Packer not found, Plugins will not be available!')
		return
	end

	-- Add plugins
	local on_startup = function(use)
		-- UTILS:
		use { -- impatient
			'lewis6991/impatient.nvim',
			config = function()
				require('impatient')
			end,
		}

		-- use {
		-- 	'folke/noice.nvim',
		-- 	event = 'VimEnter',
		-- 	config = function()
		-- 		require('plugins.noice')
		-- 	end,
		-- 	requires = {
		-- 		'MunifTanjim/nui.nvim',
		-- 		'rcarriga/nvim-notify',
		-- 	},
		-- }

		-- use { -- netman.nvim
		-- 	'miversen33/netman.nvim',
		-- 	branch = 'issue-28-libuv-shenanigans',
		-- 	config = function()
		-- 		require('netman')
		-- 	end,
		-- }

		use { -- messages
			'AckslD/messages.nvim',
			config = function()
				require('messages').setup()
			end,
		}

		use { -- Packer manages itself
			'wbthomason/packer.nvim',
		}

		use { -- Undotree
			'mbbill/undotree',
			config = function()
				vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { noremap = true })
			end,
		}

		use { -- Ask for the right file to open when file matching name is not found
			'mong8se/actually.nvim',
		}

		use { -- COLORSCHEMES;
			'tjdevries/colorbuddy.nvim',
			requires = {
				'rktjmp/lush.nvim',
				'rrethy/nvim-base16',
				'rebelot/kanagawa.nvim',
				{ 'nvim-treesitter/nvim-treesitter', opt = true },
				'christianchiarulli/nvcode-color-schemes.vim',
				'glepnir/zephyr-nvim',
				'jesseleite/nvim-noirbuddy',
				'glepnir/zephyr-nvim',
				'ali-githb/standardized',
				'th3whit3wolf/onebuddy',
				'th3whit3wolf/one-nvim',
				'ray-x/aurora',
				'edeneast/nightfox.nvim',
				'navarasu/onedark.nvim',
				'rafamadriz/neon',
				'yagua/nebulous.nvim',
				'shatur/neovim-ayu',
				'elianiva/icy.nvim',
				'ramojus/mellifluous.nvim',
				'kaiuri/nvim-juliana',
				'projekt0n/github-nvim-theme',
				'kdheepak/monochrome.nvim',
				'adisen99/codeschool.nvim',
				'nyoom-engineering/oxocarbon.nvim',
				'kvrohit/mellow.nvim',
				'kartikp10/noctis.nvim',
				{ 'everblush/everblush.nvim', as = 'everblush' },
			},
		}

		use { -- toggleterm
			'akinsho/toggleterm.nvim',
			tag = 'v2.*',
			config = function()
				require('toggleterm').setup {
					open_mapping = [[<c-\>]],
				}
			end,
		}

		use { -- gitsigns
			'lewis6991/gitsigns.nvim',
			config = function()
				require('plugins.gitsigns')
			end,
		}

		use { -- Neogit
			'TimUntersberger/neogit',
			config = function()
				require('plugins.neogit')
			end,
			cmd = 'Neogit',
			requires = {
				'sindrets/diffview.nvim',
				config = function()
					require('plugins.diffview')
				end,
				requires = 'nvim-lua/plenary.nvim',
			},
		}

		use { -- TREESITTER; integration
			'nvim-treesitter/nvim-treesitter',
			run = ':TSUpdate',
			requires = {
				'joosepalviste/nvim-ts-context-commentstring',
				'p00f/nvim-ts-rainbow',
				'nvim-treesitter/nvim-treesitter-textobjects',
				{
					'folke/todo-comments.nvim',
					config = function()
						require('plugins.todo')
					end,
				},
				{ 'kevinhwang91/nvim-bqf', ft = 'qf' },
				'andymass/vim-matchup',
				'nvim-treesitter/playground',
				'nvim-treesitter/nvim-treesitter-context',
				-- TODO:CONFIGURE:
				'ziontee113/syntax-tree-surfer',
				'folke/twilight.nvim',
				'mizlan/iswap.nvim',
				{
					'ThePrimeagen/refactoring.nvim',
					config = function()
						require('refactoring').setup()
					end,
				},
			},
			config = function()
				require('plugins.treesitter')
			end,
		}

		use {
			'ibhagwan/smartyank.nvim',
			config = function()
				require('smartyank').setup {
					highlight = {
						timeout = 200,
					},
				}
			end,
		}

		use { -- regex explainer
			'bennypowers/nvim-regexplainer',
			config = function()
				require('regexplainer').setup()
			end,
			requires = {
				'nvim-treesitter/nvim-treesitter',
				'MunifTanjim/nui.nvim',
			},
		}

		use { -- URLView
			'axieax/urlview.nvim',
			config = function()
				require('plugins.urlview')
			end,
		}

		use { -- UFO
			'kevinhwang91/nvim-ufo',
			requires = 'kevinhwang91/promise-async',
			config = function()
				require('plugins.ufo')
			end,
		}

		use { -- orgmode
			'nvim-orgmode/orgmode',
			requires = {
				'ranjithshegde/orgWiki.nvim',
				'lukas-reineke/headlines.nvim',
				'akinsho/org-bullets.nvim',
			},
			-- after = { 'nvim-cmp', 'nvim-treesitter' },
			config = function()
				require('plugins.org')
			end,
		}

		-- use {
		-- 	'chrisgrieser/nvim-recorder',
		-- 	config = function()
		-- 		require('recorder').setup {
		-- 			slots = { 'a', 'b', 'c' },
		-- 		}
		-- 	end,
		-- }

		use { -- LSP: integration
			'williamboman/mason-lspconfig.nvim',
			requires = {
				'williamboman/mason.nvim',
				'WhoIsSethDaniel/mason-tool-installer.nvim',
				'neovim/nvim-lspconfig',
				'folke/neodev.nvim',
				'SmiteshP/nvim-navic',
				'amrbashir/nvim-docs-view',
				'p00f/clangd_extensions.nvim',
				'simrat39/rust-tools.nvim',
				'Saecki/crates.nvim',
				'folke/trouble.nvim',
				'barreiroleo/ltex-extra.nvim',
				{ 'jose-elias-alvarez/null-ls.nvim', requires = { 'ThePrimeagen/refactoring.nvim' } },
				'muniftanjim/prettier.nvim',
				{ 'simrat39/rust-tools.nvim', ft = { 'rust' } },
				'b0o/schemastore.nvim',
				'aznhe21/actions-preview.nvim',
				{ 'andrewferrier/textobj-diagnostic.nvim', as = 'textobj-daig' },
				'ray-x/go.nvim',
			},
			config = function()
				require('plugins.lsp')
			end,
		}

		use { 'ralismark/vim-recover' }

		use {
			'chentoast/marks.nvim',
			config = function()
				require('marks').setup()
			end,
		}

		-- use { -- DAP:
		-- 	'mfussenegger/nvim-dap',
		--    disable = true,
		-- 	setup = function()
		-- 		require('plugins.dap').pre()
		-- 	end,
		-- 	requires = {
		-- 		'theHamsta/nvim-dap-virtual-text',
		-- 		'rcarriga/nvim-dap-ui',
		-- 		'leoluz/nvim-dap-go',
		-- 		'mfussenegger/nvim-dap-python',
		-- 		'jbyuki/one-small-step-for-vimkind',
		-- 		'nvim-telescope/telescope-dap.nvim',
		-- 	},
		-- 	config = function()
		-- 		require('plugins.dap').post()
		-- 	end,
		-- }

		use { -- ICONS:
			'kyazdani42/nvim-web-devicons',
			'yamatsum/nvim-nonicons',
			'onsails/lspkind.nvim',
		}

		-- COMPLETION:
		use { -- LUASNIP
			'L3MON4D3/LuaSnip',
			requires = 'rafamadriz/friendly-snippets',
			config = function()
				require('plugins.luasnip')
			end,
		}

		use { -- autopairs
			'windwp/nvim-autopairs',
			config = function()
				require('plugins.autopairs')
			end,
		}

		use { -- CMP
			'hrsh7th/nvim-cmp',
			config = function()
				require('plugins.cmp')
			end,
			requires = {
				'uga-rosa/cmp-dictionary',
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-nvim-lua',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-cmdline',
				'dmitmel/cmp-cmdline-history',
				'petertriho/cmp-git',
				'andersevenrud/cmp-tmux',
				-- 'rcarriga/cmp-dap',
				'quangnguyen30192/cmp-nvim-tags',
				'saadparwaiz1/cmp_luasnip',
				'f3fora/cmp-spell',
				'nvim-orgmode/orgmode',
				'ray-x/cmp-treesitter',
				'hrsh7th/cmp-nvim-lsp-signature-help',
				'windwp/nvim-autopairs',
				'delphinus/cmp-ctags',
				'onsails/lspkind.nvim',
				'tamago324/cmp-zsh',
			},
		}

		use { -- Comment.nvim
			'numToStr/Comment.nvim',
			config = function()
				require('plugins.comment')
			end,
		}

		use { -- Legacy syntaxes
			'sqwishy/vim-sqf-syntax', -- Sqf for arma3
			'tridactyl/vim-tridactyl', -- for tridactyl firefox plugin
		}

		use { -- TPOPE:
			'tpope/vim-unimpaired',
			'tpope/vim-repeat',
			'tpope/vim-fugitive',
			'tpope/vim-eunuch',
			'tpope/vim-vinegar',
		}

		use { -- nvim-surround
			'kylechui/nvim-surround',
			config = function()
				require('nvim-surround').setup()
			end,
		}

		use { -- vim-skeleton
			'noahfrederick/vim-skeleton',
			config = vim.cmd([[let g:skeleton_template_dir = "~/.config/nvim/templates"]]),
		}

		use { -- toggler
			'nat-418/boole.nvim',
			config = function()
				require('boole').setup {
					mappings = {
						increment = '<C-a>',
						decrement = '<C-a>',
					},
					addtions = {
						{ 'Foo', 'Bar' },
						{ 'foo', 'bar' },
						{ 'tic', 'tac', 'toe' },
						{ 'increment', 'decrement' },
					},
				}
			end,
		}

		use { -- FZF-LUA
			'ibhagwan/fzf-lua',
			requires = { 'kyazdani42/nvim-web-devicons' },
			config = function()
				require('plugins.fzf')
			end,
		}
		--
		use { -- TELESCOPE
			'nvim-telescope/telescope.nvim',
			branch = '0.1.x',
			requires = {
				'kyazdani42/nvim-web-devicons',
				{
					'nvim-telescope/telescope-fzf-native.nvim',
					run = 'make',
				},
			},
			config = function()
				require('plugins.telescope')
			end,
		}

		use { -- Diffview
			'sindrets/diffview.nvim',
			requires = 'nvim-lua/plenary.nvim',
		}

		use { -- KNAP
			'frabjous/knap',
			ft = { 'org', 'markdown', 'tex', 'html' },
			config = function()
				require('plugins.knap')
			end,
		}

		use { -- COLOR-PICKER
			'uga-rosa/ccc.nvim',
			config = function()
				require('plugins.misc').ccc()
			end,
		}

		use { -- NUMBERTOGGLE
			'sitiom/nvim-numbertoggle',
		}

		use { -- Table mode
			'dhruvasagar/vim-table-mode',
		}

		use { --Sniprun
			'michaelb/sniprun',
			run = 'bash ./install.sh',
		}

		-- UI:
		use { -- FIDGET
			'j-hui/fidget.nvim',
			config = function()
				require('fidget').setup {
					window = {
						blend = 0,
					},
				}
			end,
		}

		use { -- Nate Dogg and Warren G had to illuminate
			'RRethy/vim-illuminate',
		}

		use { -- BUFFERLINE
			'akinsho/bufferline.nvim',
			tag = 'v2.*',
			config = function()
				require('plugins.bufferline')
			end,
		}

		use { -- INDENT-BLANKLINE
			'lukas-reineke/indent-blankline.nvim',
			config = function()
				require('plugins.blankline')
			end,
		}

		use { -- nvim-tree
			'kyazdani42/nvim-tree.lua',
			config = function()
				require('plugins.nvimtree')
			end,
		}

		use { -- Lastplace: remember last place in file
			'ethanholz/nvim-lastplace',
			config = function()
				require('nvim-lastplace').setup {
					lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help', 'Trouble', 'terminal', 'nvimtree' },
					lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
					lastplace_open_folds = true,
				}
			end,
		}

		use { -- alpha
			'goolord/alpha-nvim',
			config = function()
				require('alpha').setup(require('plugins.alpha').config)
			end,
		}

		use { -- nvim-notify
			'rcarriga/nvim-notify',
			config = function()
				require('notify').setup {
					background_colour = '#000000',
				}
			end,
		}

		use { -- dressing
			'stevearc/dressing.nvim',
			requires = 'MunifTanjim/nui.nvim',
			config = function()
				require('plugins.dressing')
			end,
		}

		use { -- LUALINE
			'nvim-lualine/lualine.nvim',
			requires = {
				'kyazdani42/nvim-web-devicons',
				'SmiteshP/nvim-navic',
			},
			-- after = 'nvim-lspconfig',
			config = function()
				require('plugins.lualine').evil()
			end,
		}

		use {
			'kevinhwang91/nvim-hlslens',
			requires = 'kevinhwang91/nvim-scrollbar',
			config = function()
				require('hlslens').setup {
					build_position_cb = function(plist, _, _, _)
						require('scrollbar.handlers.search').handler.show(plist.start_pos)
					end,
				}
				local kopts = { noremap = true, silent = true }

				vim.api.nvim_set_keymap(
					'n',
					'n',
					[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
					kopts
				)
				vim.api.nvim_set_keymap(
					'n',
					'N',
					[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
					kopts
				)
				vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
				vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
				vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
				vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

				vim.cmd([[
        augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
        augroup END
    ]])
				vim.api.nvim_set_keymap('n', '<Leader>l', ':noh<CR>', kopts)
			end,
		}
		use {
			'petertriho/nvim-scrollbar',
			config = function()
				require('scrollbar').setup {
					handlers = {
						diagnostic = true,
						search = true, -- Requires hlslens to be loaded
						gitsigns = true, -- Requires gitsigns.nvim
					},
				}
			end,
		}

		use { -- tint.nvim
			'levouh/tint.nvim',
			config = function()
				require('tint').setup()
			end,
		}

		use { -- WHICHKEY
			'folke/which-key.nvim',
			config = function()
				require('plugins.whichkey')
			end,
		}
	end

	packer.startup {
		on_startup,
		config = {
			display = {
				open_fn = function()
					return require('packer.util').float { border = 'single' }
				end,
			},
		},
	}

	if run_sync then
		packer.sync()
		vim.notify('Please restart Neovim now for stabilty')
	end
end

return {}
