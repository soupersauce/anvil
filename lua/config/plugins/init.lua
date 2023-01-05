-- PLUGIN SETTINGS
-- Configure plugins, plugin specific functions and autocommands are to be
-- written in the corresponding files (makes debugging and trying out plugins easier)
-- local vim = vim
-- local fn = vim.fn
local M = {
	'lewis6991/impatient.nvim',
	'nvim-lua/plenary.nvim',
	'folke/lazy.nvim',
	'mong8se/actually.nvim',
  'debugloop/telescope-undo.nvim',
	'tjdevries/colorbuddy.nvim',
	'rktjmp/lush.nvim',
  'neovim/nvim-lspconfig',
	'ralismark/vim-recover',
	'onsails/lspkind.nvim',
  'p00f/clangd_extensions.nvim',
	{
		'uga-rosa/cmp-dictionary',
		config = {
			dic = {
				['*'] = { '~/.config/nvim/dictionaries/aspell_en' },
			},
			async = true,
			max_items = 10,
		},
	},
	{
		'KadoBOT/cmp-plugins',
		config = {
			files = { '.*\\.lua' }, -- default
			-- files = { "plugins.lua", "some_path/plugins/" } -
		},
	},
	{
		'petertriho/cmp-git',
		config = true,
	},
  'saadparwaiz1/cmp_luasnip',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-nvim-lua',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-cmdline',
	'dmitmel/cmp-cmdline-history',
	'andersevenrud/cmp-tmux',
	'f3fora/cmp-spell',
	'tamago324/cmp-zsh',
  'Dosx001/cmp-commit',
  'hrsh7th/cmp-path',
	-- 'rcarriga/cmp-dap',

  'b0o/schemastore.nvim',
  'MunifTanjim/nui.nvim',

  'ray-x/go.nvim',
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
	},
  {
		'lukas-reineke/headlines.nvim',
    enabled = false,
		config = function()
			local hl_ok, headlines = pcall(require, 'headlines')
			vim.cmd([[
      highlight Headline1 guibg=#883388
      highlight Headline2 guibg=#725c7b
      highlight Headline3 guibg=#5c846f
      highlight Headline4 guibg=#46ad62
      highlight Headline5 guibg=#30d556
      highlight Headline6 guibg=#1afe49
      highlight CodeBlock guibg=#1c1c1c
      highlight Dash guibg=#D19A66 gui=bold
      ]])
			headlines.setup {
				org = {
					headline_highlights = {
						'Headline1',
						'Headline2',
						'Headline3',
						'Headline4',
						'Headline5',
						'Headline6',
						'Headline5',
						'Headline4',
						'Headline3',
						'Headline2',
						'Headline1',
					},
					fat_headline_upper_string = '▃',
					fat_headline_lower_string = 'ﮋ',
					fat_headlines = false,
				},
			}
		end,
	},
	{
		'akinsho/org-bullets.nvim',
    enabled = true,
		config = function()
			local bullets = require('org-bullets')
			bullets.setup {
				concealcursor = true,
				indent = true,
			}
		end,
	},
	{
		'ranjithshegde/orgWiki.nvim',
		config = function()
			local wiki = require('orgWiki')

			local wkpath = '~/Documents/org/wiki/'
			local diary = '~/Documents/org/diary/'

			wiki.setup {
				wiki_path = wkpath,
				diary_path = diary,
			}
		end,
	},
	{
		'kyazdani42/nvim-web-devicons',
		config = { default = true },
	},
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    config = function()
      require('mason-tool-installer').setup {
      ensure_installed = {
        'blue',
        'beautysh',
        'cbfmt',
        'clang-format',
        'codespell',
        'commitlint',
        'curlylint',
        'debugpy',
        'delve',
        'diagnostic-languageserver',
        'eslint_d',
        'flake8',
        'gitlint',
        'go-debug-adapter',
        'gofumpt',
        'goimports',
        'golangci-lint',
        'gopls',
        'hadolint',
        'luacheck',
        'markdownlint',
        'mypy',
        'node-debug2-adapter',
        'powershell-editor-services',
        'prettierd',
        'proselint',
        'puppet-editor-services',
        'pylint',
        'selene',
        'shellcheck',
        'shellharden',
        'shfmt',
        'sqlfluff',
        'stylelint-lsp',
        'stylua',
        'taplo',
        'terraform-ls',
        'tectonic',
        'texlab',
        'textlint',
        'tflint',
        'vale',
        'write-good',
        'yamllint',
        -- 'debugpy-adapter',
        -- 'ansiblelint',
        -- 'checkmake',
        -- 'chktex',
        -- 'dictionary',
        -- 'latexindent',
        -- 'puppet_lint',
        'reorder-python-imports',
        'rustfmt',
        -- 'tidy',
      },
    }
  end
  },

  {
    'folke/neodev.nvim',
    config = true,
  },
  {
    'SmiteshP/nvim-navic',
    config = function ()
      require('nvim-navic').setup {
        -- highlight = true,
        safe_output = true,
        highlight = true,
        separator = " » ",
        depth = 5,
        dept_limit_indicator = "",
      }
    end,
  },
  {
    'amrbashir/nvim-docs-view',
    config = true,
    cmd = 'DocsViewToggle',
  },
  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    config = function()
      require('crates').setup {
        null_ls = {
          enabled = true,
          name = 'crates',
        },
      }
    end,
  },
  {
    'williamboman/mason.nvim',
    config = true,
  },
  {
    'folke/trouble.nvim',
    config = true,
  },
    'barreiroleo/ltex-extra.nvim',
  {
    'muniftanjim/prettier.nvim',
    config = {
      bin = 'prettierd',
      filetypes = {
        'css',
        'graphql',
        'html',
        'javascript',
        'javascriptreact',
        'json',
        'less',
        'markdown',
        'scss',
        'typescript',
        'typescriptreact',
        'yaml',
        'org',
      },
    },
  },
  { 'simrat39/rust-tools.nvim', ft = { 'rust' }, },
  {
    'aznhe21/actions-preview.nvim',
    config = {
      backend = { 'telescope', 'nui' },
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    config = function () 
      require("various-textobjs").setup({ useDefaultKeymaps = true })
    end,
  },

	-- tim pope
	'tpope/vim-unimpaired',
	'tpope/vim-repeat',
	'tpope/vim-fugitive',
	'tpope/vim-eunuch',
	'tpope/vim-vinegar',

	'sitiom/nvim-numbertoggle',

	'dhruvasagar/vim-table-mode',
	'RRethy/vim-illuminate',

	-- Synaxes
	'sqwishy/vim-sqf-syntax', -- Sqf for arma3
	'tridactyl/vim-tridactyl', -- for tridactyl firefox plugin

	{ -- toggleterm
		'akinsho/toggleterm.nvim',
		config = {
			open_mapping = [[<c-\>]],
		},
	},
	{
		'ibhagwan/smartyank.nvim',
		config = {
			highlight = {
				timeout = 200,
			},
		},
	},
	{ -- regex explainer
		'bennypowers/nvim-regexplainer',
		config = true,
	},
	{
		'chentoast/marks.nvim',
		config = true,
	},
	{ -- nvim-surround
		'kylechui/nvim-surround',
		config = true,
	},
	{
		'cvigilv/esqueleto.nvim',
		config = {
			directory = '~/.config/nvim/templates',
			patterns = { 'org' },
		},
	},
	-- { -- vim-skeleton
	--   'noahfrederick/vim-skeleton',
	--   config = function()
	--     vim.cmd([[let g:skeleton_template_dir = "~/.config/nvim/templates"]])
	--   end,
	-- },
	{ -- toggler
		'nat-418/boole.nvim',
		config = {
			mappings = {
				increment = '<C-a>',
				decrement = '<C-x>',
			},
			additions = {
				{ 'increment', 'decrement' },
			},
		},
	},
	{ --Sniprun
		'michaelb/sniprun',
		build = 'bash ./install.sh',
	},
	{ -- FIDGET
		enabled = false,
		'j-hui/fidget.nvim',
		config = {
			window = {
				blend = 1,
			},
		},
	},
	{ -- Lastplace: remember last place in file
		'ethanholz/nvim-lastplace',
		config = {
			lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help', 'Trouble', 'terminal', 'nvimtree' },
			lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
			lastplace_open_folds = true,
		},
	},
	{ -- nvim-notify
		'rcarriga/nvim-notify',
		config = true,
	},
	{ -- scrollbar
		'petertriho/nvim-scrollbar',
		config = {
			handlers = {
				diagnostic = true,
				search = true, -- Requires hlslens to be loaded
				gitsigns = true, -- Requires gitsigns.nvim
			},
		},
	},
	{ -- tint.nvim
		'levouh/tint.nvim',
		config = true,
	},
}

-- use { -- netman.nvim
-- 	'miversen33/netman.nvim',
-- 	branch = 'issue-28-libuv-shenanigans',
-- 	config = function()
-- 		require('netman')
-- 	end,
-- }

-- use {
-- 	'chrisgrieser/nvim-recorder',
-- 	config = function()
-- 		require('recorder').setup {
-- 			slots = { 'a', 'b', 'c' },
-- 		}
-- 	end,
-- }
-- {
-- { -- DAP:
-- 	'mfussenegger/nvim-dap',
-- 	setup = function()
-- 		require('plugins.dap').pre()
-- 	end,
-- 	config = function()
-- 		require('plugins.dap').post()
-- 	end,
-- },
-- 		'theHamsta/nvim-dap-virtual-text',
-- 		'rcarriga/nvim-dap-ui',
-- 		'leoluz/nvim-dap-go',
-- 		'mfussenegger/nvim-dap-python',
-- 		'jbyuki/one-small-step-for-vimkind',
-- 		'nvim-telescope/telescope-dap.nvim',
-- }
return M
