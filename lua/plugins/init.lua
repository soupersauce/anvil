-- PLUGIN SETTINGS
-- Configure plugins, plugin specific functions and autocommands are to be
-- written in the corresponding files (makes debugging and trying out plugins easier)

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
	-- loads stuff fast
	use {
		'lewis6991/impatient.nvim',
		config = function()
			require('impatient')
		end,
	}
	-- Skyrim script extender
	use { 'nvim-lua/plenary.nvim' }
	-- Packer manages itself
	use { 'wbthomason/packer.nvim' }
	-- Ask for the right file to open when file matching name is not found
	use('EinfachToll/DidYouMean')

	-- COLORSCHEMES:
	use {
		'christianchiarulli/nvcode-color-schemes.vim',
		'glepnir/zephyr-nvim',
		'th3whit3wolf/onebuddy',
		'th3whit3wolf/one-nvim',
		'ray-x/aurora',
		'tanvirtin/nvim-monokai',
		'nekonako/xresources-nvim',
		'marko-cerovac/material.nvim',
		'dilangmb/nightbuddy',
		'edeneast/nightfox.nvim',
		'navarasu/onedark.nvim',
		'rafamadriz/neon',
		'yagua/nebulous.nvim',
		'shatur/neovim-ayu',
		'elianiva/icy.nvim',
		'sainnhe/edge',
		'sainnhe/sonokai',
		'sainnhe/everforest',
		'sainnhe/gruvbox-material',
		'projekt0n/github-nvim-theme',
		{
			'adisen99/codeschool.nvim',
			requires = 'rktjmp/lush.nvim',
			config = function()
				require('lush')(require('codeschool').setup())
			end,
		},
		-- config = function() require('github-theme').setup {
		--   theme_style = "dimmed",
		-- }
		-- end
	}

	-- Git integration
	use {
		'lewis6991/gitsigns.nvim',
		config = function()
			require('plugins.gitsigns')
		end,
	}

	use {
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

	-- REPL integration
	-- use {
	--   'rhysd/reply.vim',
	--   cmd = {'Repl', 'ReplAuto', 'ReplSend'},
	--   config = function() require('plugins.reply') end
	-- }

	-- TREESITTER: integration
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		requires = {
			'joosepalviste/nvim-ts-context-commentstring',
			'p00f/nvim-ts-rainbow',
			'andymass/vim-matchup',
			'nvim-treesitter/playground',
			'nvim-treesitter/nvim-treesitter-context',
			'lewis6991/spellsitter.nvim',
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

	-- TODO:CONFIGURE:
	use {
		'nvim-orgmode/orgmode',
		wants = { 'cmp', 'treesitter' },
		config = function()
			require('orgmode').setup {
				org_agenda_files = '~/Documents/org/*',
				org_default_notes_file = '~/Documents/org/refile.org',
			}
		end,
	}

	use {
		'ranjithshegde/orgWiki.nvim',
		config = function()
			require('orgWiki').setup {
				wiki_path = { '~/Documents/org/wiki/' },
				diary_path = '~/Documents/org/diary/',
			}
		end,
		after = 'orgmode',
	}

	-- LSP: integration
	-- TODO:CONFIGURE:
	use {
		'junnplus/nvim-lsp-setup',
		requires = {
			'williamboman/nvim-lsp-installer',
			'neovim/nvim-lspconfig',
			'folke/lua-dev.nvim',
			'SmiteshP/nvim-navic',
			'amrbashir/nvim-docs-view',
			'p00f/clangd_extensions.nvim',
			{
				'jose-elias-alvarez/null-ls.nvim',
				requires = {
					'ThePrimeagen/refactoring.nvim',
				},
			},
			'ray-x/lsp_signature.nvim',
			{
				'simrat39/rust-tools.nvim',
				ft = { 'rust' },
			},
			{
				'kosayoda/nvim-lightbulb',
				requires = 'antoinemadec/FixCursorHold.nvim',
				config = function()
					require('nvim-lightbulb').setup {}
				end,
			},
			{
				'weilbith/nvim-code-action-menu',
				cmd = 'CodeActionMenu',
			},
		},
		config = function()
			require('plugins.lsp')
		end,
	}

	-- DEBUGGING: Configuration
	-- DAP:
	-- TODO:CONFIGURE:
	-- TODO:Figure out how to install shit
	use {
		'mfussenegger/nvim-dap',
		requires = {
			'theHamsta/nvim-dap-virtual-text',
			'rcarriga/nvim-dap-ui',
			'leoluz/nvim-dap-go',
			'mfussenegger/nvim-dap-python',
			-- { 'pocco81/dap-buddy.nvim', config = function() require('plugins.dap') end }
		},
	}

	-- ICONS:
	use { 'kyazdani42/nvim-web-devicons' }

	use { 'yamatsum/nvim-nonicons', requires = { 'kyazdani42/nvim-web-devicons' } }

	use { 'onsails/lspkind.nvim' }

	-- COMPLETION:
	-- Snippet and completion integration
	-- Use LuaSnip as snippet provider
	use {
		'L3MON4D3/LuaSnip',
		requires = 'rafamadriz/friendly-snippets',
		config = function()
			require('plugins.luasnip')
		end,
	}

	use {
		'windwp/nvim-autopairs',
		config = function()
			require('plugins.autopairs')
		end,
	}

	-- TODO:CONFIGURE:
	use {
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

	-- For commenting
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('plugins.comment')
		end,
	}

	use { 'sqwishy/vim-sqf-syntax' }

	-- TPOPE:
	-- TODO:CONFIGURE:
	use { 'tpope/vim-unimpaired' }
	-- TODO:CONFIGURE:
	use { 'tpope/vim-repeat' }
	-- TODO:CONFIGURE:
	use { 'tpope/vim-surround' }
	-- TODO:CONFIGURE:
	use { 'tpope/vim-fugitive' }
	-- TODO:CONFIGURE:
	use { 'tpope/vim-eunuch' }
	-- TODO:CONFIGURE:
	use { 'tpope/vim-vinegar' }

	-- TODO:CONFIGURE:
	use {
		'noahfrederick/vim-skeleton',
		config = vim.cmd([[let g:skeleton_template_dir = "~/.config/nvim/templates"]]),
	}

	-- use { "luukvbaal/nnn.nvim" }

	-- TODO:CONFIGURE:
	use { 'ibhagwan/fzf-lua', requires = { 'kyazdani42/nvim-web-devicons' } }

	-- TODO:CONFIGURE:
	use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

	-- TODO:CONFIGURE:
	use {
		'frabjous/knap',
		config = function()
			require('plugins.knap')
		end,
	}

	use {
		'declancm/cinnamon.nvim',
		config = function()
			require('cinnamon').setup {
				extra_keymaps = true,
				extended_keymaps = true,
				delay = 0,
			}
		end,
	}

	-- use {
	-- 	'nkakouros-original/numbers.nvim',
	-- 	config = function()
	-- 		require('numbers').setup {
	-- 			excluded_filetypes = {
	-- 				'alpha',
	-- 				'NvimTree',
	-- 				'help',
	-- 				'undotree',
	-- 				'NeogitStatus',
	-- 				'NeogitCommitMessage',
	-- 				'NeogitPopup',
	-- 			},
	-- 		}
	-- 	end,
	-- }
    use {
    'sitiom/nvim-numbertoggle',
    config = function() require('numbertoggle').setup {} end,
  }

	use { 'dhruvasagar/vim-table-mode' }

	-- TODO:CONFIGURE:
	use { 'michaelb/sniprun', run = 'bash ./install.sh' }

	-- UI:
	-- TODO:CONFIGURE:
	use {
		'lukas-reineke/headlines.nvim',
		config = function()
			require('headlines').setup {
				org = {},
			}
		end,
	}

	use {
		'akinsho/org-bullets.nvim',
		config = function()
			require('org-bullets').setup {}
		end,
	}

	-- Visualise and control undo history in tree form.
	use {
		'jiaoshijie/undotree',
		cmd = { 'UndotreeToggle', 'UndotreeFocus', 'UndotreeHide', 'UndotreeShow' },
		setup = function()
			vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true })
		end,
	}

	use {
		'j-hui/fidget.nvim',
		config = function()
			require('fidget').setup {}
		end,
	}

	use { 'xiyaowong/nvim-cursorword' }

	use {
		'akinsho/bufferline.nvim',
		tag = 'v2.*',
		config = function()
			require('plugins.bufferline')
		end,
	}

	-- TODO:CONFIGURE:
	use {
		'lukas-reineke/indent-blankline.nvim',
		config = function()
			require('plugins.blankline')
		end,
	}

	-- TODO:CONFIGURE:
	use {
		'kyazdani42/nvim-tree.lua',
		cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
		config = function()
			require('plugins.nvimtree')
		end,
	}
	use {
		'norcalli/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup()
		end,
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons' },
		config = function()
			require('plugins.lualine')
		end,
	}

	-- Keymap hints
	-- Load after rest of gui
	-- TODO:CONFIGURE:
	use {
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
