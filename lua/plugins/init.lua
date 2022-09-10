-- PLUGIN SETTINGS
-- Configure plugins, plugin specific functions and autocommands are to be
-- written in the corresponding files (makes debugging and trying out plugins easier)
local vim = vim
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

	use { -- Packer manages itself
		'wbthomason/packer.nvim',
	}

	use { -- Undotree
		'jiaoshijie/undotree',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('plugins.undotree')
		end,
	}

	use { -- Ask for the right file to open when file matching name is not found
		'EinfachToll/DidYouMean',
	}

	use { -- COLORSCHEMES:
		'tjdevries/colorbuddy.nvim',
		requires = {
			'rktjmp/lush.nvim',
			{ 'nvim-treesitter/nvim-treesitter', opt = true },
			'christianchiarulli/nvcode-color-schemes.vim',
			'glepnir/zephyr-nvim',
			'th3whit3wolf/onebuddy',
			'th3whit3wolf/one-nvim',
			'ray-x/aurora',
			'nekonako/xresources-nvim',
			'edeneast/nightfox.nvim',
			'navarasu/onedark.nvim',
			'rafamadriz/neon',
			'yagua/nebulous.nvim',
			'shatur/neovim-ayu',
			'elianiva/icy.nvim',
			'kaiuri/nvim-juliana',
			'projekt0n/github-nvim-theme',
			'kdheepak/monochrome.nvim',
			'adisen99/codeschool.nvim',
			'b4mbus/oxocarbon-lua.nvim',
			{ 'everblush/everblush.nvim', as = 'everblush' },
		},
		config = function()
			require('plugins.colorscheme').init()
		end,
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

	use { -- git-conflict
		'akinsho/git-conflict.nvim',
		tag = '*',
		config = function()
			require('git-conflict').setup {
				default_mappings = true, -- disable buffer local mapping created by this plugin
				disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
				highlights = { -- They must have background color, otherwise the default color will be used
					incoming = 'DiffText',
					current = 'DiffAdd',
				},
			}
		end,
	}

	use { -- TREESITTER: integration
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		requires = {
			'joosepalviste/nvim-ts-context-commentstring',
			'p00f/nvim-ts-rainbow',
			'nvim-treesitter/nvim-treesitter-textobjects',
			{
				'folke/todo-comments.nvim',
				config = function()
					-- HACK: #104 Invalid in command-line window
					local hl = require('todo-comments.highlight')
					local highlight_win = hl.highlight_win
					hl.highlight_win = function(win, force)
						pcall(highlight_win, win, force)
					end
					require('todo-comments').setup {
						highlight = {
							exclude = { 'vim', 'packer', 'NeogitStatus', 'NeogitPopup', 'nofile', 'terminal' },
						},
					}
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

	use { -- LSP: integration
		'junnplus/lsp-setup.nvim',
		requires = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			'neovim/nvim-lspconfig',
			'folke/lua-dev.nvim',
			'SmiteshP/nvim-navic',
			'amrbashir/nvim-docs-view',
			'p00f/clangd_extensions.nvim',
			'simrat39/rust-tools.nvim',
			'Saecki/crates.nvim',
			'folke/trouble.nvim',
			'barreiroleo/ltex-extra.nvim',
			{ 'jose-elias-alvarez/null-ls.nvim', requires = { 'ThePrimeagen/refactoring.nvim' } },
			'muniftanjim/prettier.nvim',
			'ray-x/lsp_signature.nvim',
			{ 'simrat39/rust-tools.nvim', ft = { 'rust' } },
			{ 'kosayoda/nvim-lightbulb', requires = 'antoinemadec/FixCursorHold.nvim' },
			{ 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' },
			{ 'andrewferrier/textobj-diagnostic.nvim', as = 'textobj-daig' },
			'ray-x/go.nvim',
		},
		config = function()
			require('plugins.lsp')
		end,
	}

	use { -- DAP:
		'mfussenegger/nvim-dap',
		setup = function()
			require('plugins.dap').pre()
		end,
		requires = {
			'theHamsta/nvim-dap-virtual-text',
			'rcarriga/nvim-dap-ui',
			'leoluz/nvim-dap-go',
			'mfussenegger/nvim-dap-python',
			'jbyuki/one-small-step-for-vimkind',
			'nvim-telescope/telescope-dap.nvim',
		},
		config = function()
			require('plugins.dap').post()
		end,
	}

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
			'petertriho/cmp-git',
			'andersevenrud/cmp-tmux',
			'rcarriga/cmp-dap',
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

	use { -- SQF for Arma3
		'sqwishy/vim-sqf-syntax',
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
		'nguyenvukhang/nvim-toggler',
		config = function()
			require('nvim-toggler').setup {
				remove_default_keybinds = true,
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
		'ziontee113/color-picker.nvim',
		config = function()
			require('color-picker').setup {}
		end,
	}

	use { -- CINNAMON
		'declancm/cinnamon.nvim',
		config = function()
			require('cinnamon').setup {
				delay = 0,
			}
		end,
	}

	use { -- NUMBERTOGGLE
		'sitiom/nvim-numbertoggle',
		config = function()
			require('numbertoggle').setup()
		end,
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
			require('fidget').setup {}
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
		cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
		config = function()
			require('plugins.nvimtree')
		end,
	}

	use { -- colorizer
		'nvchad/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup()
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
			require('notify').setup()
		end,
	}

	-- use { -- dressing
	-- 	'stevearc/dressing.nvim',
	-- 	disable = false,
	-- 	requires = 'MunifTanjim/nui.nvim',
	-- 	config = function()
	-- 		require('plugins.dressing')
	-- 	end,
	-- }

	use { 'ray-x/guihua.lua' }

	use { -- LUALINE
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons' },
		config = function()
			require('plugins.lualine')
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
