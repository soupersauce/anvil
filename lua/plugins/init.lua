-- PLUGIN SETTINGS
-- Configure plugins, plugin specific functions and autocommands are to be
-- written in the corresponding files (makes debuging and trying out plugins easier)

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local run_sync = false

-- Install packer for package management, if missing
if (fn.empty(fn.glob(install_path, _, _)) > 0) then
  run_sync = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
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
    "lewis6991/impatient.nvim",
    config = function() require('impatient') end,
  }
  -- Skyrim script extender
  use { "nvim-lua/plenary.nvim" }
  -- Packer manages itself
  use { 'wbthomason/packer.nvim' }
  -- TODO:CONFIGURE:
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
      config = function() require('lush')(require('codeschool').setup()) end,
    },
    -- config = function() require('github-theme').setup {
    --   theme_style = "dimmed",
    -- }
    -- end
  }

  -- Git integration
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('plugins.gitsigns') end
  }
  --  TODO: Explore and see if we will use
  -- use {
  --   'TimUntersberger/neogit',
  --   config = function() require('plugins.neogit') end,
  --   cmd = 'Neogit',
  --   requires = {
  --     'sindrets/diffview.nvim',
  --     config = function() require('plugins.diffview') end,
  --     requires = 'nvim-lua/plenary.nvim'
  --   }
  -- }


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
    requires =
      {
        {'nvim-treesitter/nvim-treesitter-context', config = function() require('treesitter-context').setup {} end },
        'joosepalviste/nvim-ts-context-commentstring',
        'p00f/nvim-ts-rainbow',
        'andymass/vim-matchup',
        'nvim-treesitter/playground',
    -- TODO:CONFIGURE:
        { "lewis6991/spellsitter.nvim", config = function() require("spellsitter").setup() end },
    -- TODO:CONFIGURE:
        { "ziontee113/syntax-tree-surfer", config = function() require("syntax-tree-surfer").setup() end },
    -- TODO: CONFIGURE:
        { 'folke/twilight.nvim', requires = 'nvim-treesitter', config = function() require('twilight').setup {} end }
    -- TODO:CONFIGURE: use { "mizlan/iswap.nvim", }
    },
    config = function() require('plugins.treesitter') end,
  }

  -- TODO:CONFIGURE:
  use {
    "nvim-orgmode/orgmode",
    require = { 'cmp', 'treesitter' },
    config = function() require('orgmode').setup {} end
  }

  -- LSP: integration
  -- TODO:CONFIGURE:
  use {
    "junnplus/nvim-lsp-setup",
    requires = {
      'williamboman/nvim-lsp-installer',
      'neovim/nvim-lspconfig',
      -- TODO:CONFIGURE: config = function() require('plugins.lspconfig') end,
      {
        "simrat39/rust-tools.nvim",
        ft = { "rust", },
        config = function() require("rust-tools").setup({}) end,
      },
      "folke/lua-dev.nvim",
      -- Navic: show current code context in statusbar
      -- TODO:CONFIGURE:
      {"SmiteshP/nvim-navic", config = function() require("nvim-navic").setup {} end,},
      -- TODO:CONFIGURE:
      {"amrbashir/nvim-docs-view", config = function() require("docs-view").setup {} end},
      -- TODO: Look at clangd extensions
      { "p00f/clangd_extensions.nvim", config = function() require("clangd_extensions").setup() end }
    },
    config = function() require('plugins.lsp') end,
  }

  -- Integrates linters/diagnostics/formatting into LSP
  -- TODO:CONFIGURE:
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function() require('plugins.null-ls') end,
  }

  -- DEBUGGING: Configuration
  -- DAP:
  -- TODO:CONFIGURE:
  -- TODO:Figure out how to install shit
  use {
    'mfussenegger/nvim-dap',
    requires = {
      { 'theHamsta/nvim-dap-virtual-text' },
      { 'rcarriga/nvim-dap-ui' },
      { 'leoluz/nvim-dap-go', config = function() require('dap-go').setup() end },
      -- { 'pocco81/dap-buddy.nvim', config = function() require('plugins.dap') end }
    },
  }

  -- ICONS:
  use { "kyazdani42/nvim-web-devicons" }

  -- TODO:CONFIGURE:
  use { 'yamatsum/nvim-nonicons',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- TODO:CONFIGURE:
  use { "onsails/lspkind.nvim" }

  -- COMPLETION:
  -- Snippet and completion integration
  -- Use LuaSnip as snippet provider
  use {
    'L3MON4D3/LuaSnip',
    requires = 'rafamadriz/friendly-snippets',
    config = function() require('plugins.luasnip') end,
  }

  use { 'rafamadriz/friendly-snippets', }

  use {
    "windwp/nvim-autopairs",
    config = function() require("plugins.autopairs") end,
  }

  -- TODO:CONFIGURE:
  use {
    'hrsh7th/nvim-cmp',
    config = function() require('plugins.cmp') end,
    requires = {
      'uga-rosa/cmp-dictionary',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
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
    },
  }

  -- For commenting
  use {
    "numToStr/Comment.nvim",
    config = function() require("plugins.comment") end
  }

  use { "sqwishy/vim-sqf-syntax" }

  -- TPOPE:
  -- TODO:CONFIGURE:
  use { "tpope/vim-unimpaired" }
  -- TODO:CONFIGURE:
  use { "tpope/vim-repeat" }
  -- TODO:CONFIGURE:
  use { "tpope/vim-surround" }
  -- TODO:CONFIGURE:
  use { "tpope/vim-fugitive" }
  -- TODO:CONFIGURE:
  use { "tpope/vim-eunuch" }
  -- TODO:CONFIGURE:
  use { "tpope/vim-vinegar" }

  -- use { "luukvbaal/nnn.nvim" }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', },
    config = function() require('plugins.lualine') end,
  }

  -- TODO:CONFIGURE:
  use { 'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- TODO:CONFIGURE:
  use { "sindrets/diffview.nvim",
    requires = 'nvim-lua/plenary.nvim',
  }

  -- TODO:CONFIGURE:
  use {
    "frabjous/knap",
    config = function() require("plugins.knap") end,
  }

  use {
    'declancm/cinnamon.nvim',
    config = function() require('cinnamon').setup {
        extra_keymaps = true,
        extended_keymaps = true,
        delay = 1,
      }
    end
  }

  use {
    "nkakouros-original/numbers.nvim",
    config = function() require('numbers').setup {
        excluded_filetypes = {
          'alpha', 'NvimTree', 'help',
        }
      }
    end
  }

  -- TODO:CONFIGURE:
  use { "dhruvasagar/vim-table-mode" }

  -- TODO:CONFIGURE:
  use { "michaelb/sniprun", run = "bash ./install.sh" }

  -- UI:
  -- TODO:CONFIGURE:
  use { "lukas-reineke/headlines.nvim",
    config = function() require('headlines').setup() end
  }

  use { "akinsho/org-bullets.nvim",
    config = function() require('org-bullets').setup {} end
  }

  -- Visualise and control undo history in tree form.
  use {
    'jiaoshijie/undotree',
    cmd = { 'UndotreeToggle', 'UndotreeFocus', 'UndotreeHide', 'UndotreeShow' },
    config = function()
      vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true })
    end
  }

  use {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup {} end
  }

  use { "xiyaowong/nvim-cursorword" }

  -- TODO:CONFIGURE:
  use { "akinsho/bufferline.nvim",
    tag = "v2.*",
    config = function()
      require "plugins.bufferline"
    end,
  }

  -- TODO:CONFIGURE:
  use { "lukas-reineke/indent-blankline.nvim",
    config = function() require("plugins.blankline") end
  }

  -- TODO:CONFIGURE:
  use { "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function() require "plugins.nvimtree" end
  }
  use {
    "norcalli/nvim-colorizer.lua",
    config = function() require('colorizer').setup() end,
  }

  -- Keymap hints
  -- Load after rest of gui
  -- TODO: May remove these completely in favor of just using which-key
  use { "gennaro-tedesco/nvim-peekup" }

  -- TODO:CONFIGURE:
  use {
    "folke/which-key.nvim",
    config = function()
      require("plugins.whichkey")
    end
  }
end

packer.startup({
  on_startup,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})

if run_sync then
  packer.sync()
  vim.notify('Please restart Neovim now for stabilty')
end
