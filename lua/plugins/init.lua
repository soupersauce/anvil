-- PLUGIN SETTINGS
-- Configure plugins, plugin specific functions and autocommands are to be
-- written in the corresponding files (makes debuging and trying out plugins easier)

-- Use a protected call to avoid errors on first use
local status_ok, packer = pcall(require, 'packer')
  if not status_ok then
  return
end

-- Add plugins
local on_startup = function(use)

  use { "nvim-lua/plenary.nvim" }

  -- Set packer to manage itself
  use { 'wbthomason/packer.nvim' }

  use { "lewis6991/impatient.nvim" }

  -- Color schemes
  use { 'christianchiarulli/nvcode-color-schemes.vim' }
  use { 'glepnir/zephyr-nvim' }
  use { 'th3whit3wolf/onebuddy' }
  use { 'th3whit3wolf/one-nvim' }
  use { 'ray-x/aurora' }
  use { 'tanvirtin/nvim-monokai' }
  use { 'nekonako/xresources-nvim' }
  use { 'marko-cerovac/material.nvim' }
  use { 'dilangmb/nightbuddy' }
  use { 'edeneast/nightfox.nvim' }
  use {
    'klooj/noogies',
    requires = 'tjdevries/colorbuddy.nvim',
  }
  use { 'navarasu/onedark.nvim' }
  use { 'rafamadriz/neon' }
  use { 'yagua/nebulous.nvim' }
  use { 'shatur/neovim-ayu' }
  use { 'elianiva/icy.nvim' }
  use {
    'adisen99/codeschool.nvim',
    requires = 'rktjmp/lush.nvim',
  }
  use { 'sainnhe/edge' }
  use { 'sainnhe/sonokai' }
  use { 'sainnhe/everforest' }
  use { 'sainnhe/gruvbox-material' }
  use { "projekt0n/github-nvim-theme",
    config = function() require('github-theme').setup {
      theme_style = "dimmed",
    }
    end
  }
  use { "onsails/lspkind.nvim" }

  -- Ask for the right file to open when file matching name is not found
  use { 'EinfachToll/DidYouMean' }

  -- Visualise and control undo history in tree form.
  use {
    'mbbill/undotree',
    cmd = {'UndotreeToggle', 'UndotreeFocus', 'UndotreeHide', 'UndotreeShow'},
    config = function()
      vim.keymap.set('n', ',r', ':UndotreeToggle<CR>', { noremap = true })
    end
  }

  use {"numToStr/Comment.nvim",
      config = function()
         require("Comment").setup() end
   }

  -- Git integration
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('plugins.gitsigns')

      -- Create User command for opening gitui in neovim, if installed
      if (vim.fn.executable('gitui') == 1) then
          vim.api.nvim_create_user_command('GitUI', 'edit term://gitui', {})
      end
    end,
    -- requires = {'tpope/vim-fugitive', 'rbong/vim-flog'}
  }

  use {"p00f/clangd_extensions.nvim",
      config = function()
         require("clangd_extensions").setup() end
   }

  -- REPL integration
  -- use {
  --   'rhysd/reply.vim',
  --   cmd = {'Repl', 'ReplAuto', 'ReplSend'},
  --   config = function() require('plugins.reply') end
  -- }

  -- TreeSitter integration
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('plugins.treesitter') end,
    run = ':TSUpdate',
    requires = 'nvim-ts-rainbow',
  }

  use {
    'p00f/nvim-ts-rainbow',
    requires = 'nvim-treesitter',
  }

  use {"folke/lua-dev.nvim",
      config = function()
         require("lua-dev").setup() end
   }

  use {
    'nvim-treesitter/nvim-treesitter-context',
    requires = 'nvim-treesitter',
    config = function() require('treesitter-context').setup {} end
  }

  use {
    'folke/twilight.nvim',
    requires = 'nvim-treesitter',
    config = function() require('twilight').setup {} end
  }

  -- DAP integration
  use {
    'mfussenegger/nvim-dap',
    config = function() end,
    requires = {
      { 'theHamsta/nvim-dap-virtual-text' },
      { 'rcarriga/nvim-dap-ui' },
      { 'leoluz/nvim-dap-go', config = function() require('dap-go').setup() end  },
    },
  }


  use {"andymass/vim-matchup", }

  use {"lewis6991/spellsitter.nvim",
      config = function()
         require("spellsitter").setup() end
   }

  use {"ziontee113/syntax-tree-surfer",
      config = function()
         require("syntax-tree-surfer").setup() end
   }

  -- LSP integration
  use {
    'neovim/nvim-lspconfig',
    config = function() require('plugins.lspconfig') end,
    -- run = {
    --   'command -v solargraph >/dev/null || gem install solargraph',
    --   'command -v gopls >/dev/null || go install golang.org/x/tools/gopls@latest',
    --   'command -v typescript-language-server >/dev/null || npm install -g typescript-language-server',
    -- }
  }

  use {
     "SmiteshP/nvim-navic",
      requires = "nvim-lspconfig",
      config = function()
         require("nvim-navic").setup {} end
  }

  -- use { "mfussenegger/nvim-lint",
  --   module = 'lint',
  --   setup = function() require('lint').linters_by_ft = {
  --       yaml = {'yamllint'},
  --       ansible = {'ansible_lint'},
  --       html = {'tidy'},
  --       lua = {'luacheck'},
  --       python = {'pylint'},
  --   }
		--end
  -- }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function() require('plugins.null-ls') end,
  }

  use { "gennaro-tedesco/nvim-peekup" }

  use { "kyazdani42/nvim-web-devicons" }

  use { 'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  use { 'yamatsum/nvim-nonicons',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  use {
    "frabjous/knap",
    config = function() require("plugins.knap") end,
  }

  use { "xiyaowong/nvim-cursorword" }

  use {
    "simrat39/rust-tools.nvim",
    ft = { "rust", },
    config = function() require("rust-tools").setup({}) end,
  }

  use {
    "junnplus/nvim-lsp-setup",
    requires = {
        'neovim/nvim-lspconfig',
        'williamboman/nvim-lsp-installer',
    },
    config = function() require('plugins.lsp-setup') end,
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', }
  }

  -- Use LuaSnip as snippet provider
  use {
    'L3MON4D3/LuaSnip',
    requires = 'rafamadriz/friendly-snippets',
    config = function() require('plugins.luasnip') end,
  }

  -- Snippet and completion integration
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
      'quangnguyen30192/cmp-nvim-tags',
      'saadparwaiz1/cmp_luasnip',
      'f3fora/cmp-spell',
      'nvim-orgmode/orgmode',
      'ray-x/cmp-treesitter',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'windwp/nvim-autopairs',
      'delphinus/cmp-ctags',
    }
  }

  use {
    "amrbashir/nvim-docs-view",
    config = function()
        require("docs-view").setup {} end
  }

  use {
    "nkakouros-original/numbers.nvim",
    config = function() require('numbers').setup {
      excluded_filetypes = {
        'alpha', 'NvimTree',
      }
    }
end
  }

  use { "luukvbaal/nnn.nvim" }

  use {
    "windwp/nvim-autopairs",
    config = function() require("plugins.autopairs") end,
  }

  use {
    'declancm/cinnamon.nvim',
    config = function() require('cinnamon').setup {
      extra_keymaps = true,
      extended_keymaps = true,
      delay = 1,
  } end
  }

  use { "sindrets/diffview.nvim",
    requires = 'nvim-lua/plenary.nvim',
  }

  use { "mizlan/iswap.nvim",
    requires = 'nvim-treesitter',
  }

  use { "tpope/vim-unimpaired" }

  use { "tpope/vim-repeat" }

  use { "tpope/vim-surround" }

  use { "tpope/vim-fugitive" }

  use { "tpope/vim-eunuch" }

  use { "tpope/vim-vinegar" }

  use {
    "nvim-orgmode/orgmode",
    require = { 'cmp', 'treesitter' },
    config = function() require('orgmode').setup{} end
  }

  use { "dhruvasagar/vim-table-mode" }

  use {"michaelb/sniprun", run = "bash ./install.sh"}

  use { "lukas-reineke/headlines.nvim",
        config = function() require('headlines').setup() end
      }

  use { "akinsho/org-bullets.nvim",
        config = function() require('org-bullets').setup{} end
      }

  use { "sqwishy/vim-sqf-syntax" }


  use { "akinsho/bufferline.nvim",
      tag = "v2.*",
      config = function()
         require "plugins.bufferline"
      end,
   }

  use { "lukas-reineke/indent-blankline.nvim",
     config = function() require("plugins.blankline") end
  }

  use { "kyazdani42/nvim-tree.lua",
     cmd = { "NvimTreeToggle", "NvimTreeFocus" },
     config = function() require "plugins.nvimtree" end
  }

-- Keymap hints
-- Load after rest of gui
  use {
      "folke/which-key.nvim",
      config = function()
        require("plugins.whichkey")
      end
  }
end

return {
  setup = function(run_sync)
    local config = packer.startup({
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
    end

    return config
  end
}

