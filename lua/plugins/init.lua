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
  use { 'sainnhe/everforest' }
  use { 'sainnhe/gruvbox-material' }
  use { "projekt0n/github-nvim-theme",
    config = function() require('github-theme').setup {
      theme_style = "dimmed",
    }
    end
  }

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


  -- DAP integration
  -- use {
  --   'mfussenegger/nvim-dap',
  --   config = function() end,
  --   requires = {
  --     { 'theHamsta/nvim-dap-virtual-text' },
  --     { 'rcarriga/nvim-dap-ui' },
  --     { 'leoluz/nvim-dap-go', config = function() require('dap-go').setup() end  },
  --   },
  -- }

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
         require("nvim-navic").setup({}) end
  }

  use { "mfussenegger/nvim-lint",
    module = 'lint',
    setup = function() require('lint').linters_by_ft = {
        yaml = {'yamllint'},
        ansible = {'ansible_lint'},
        html = {'tidy'},
        lua = {'luacheck'},
        python = {'pylint'},
    }
		end
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
    "junnplus/nvim-lsp-setup",
    requires = {
        'neovim/nvim-lspconfig',
        'williamboman/nvim-lsp-installer',
    }
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', }
  }

  -- Copilot integration
  -- use {
  --   'zbirenbaum/copilot.lua',
  --   config = function()
  --     vim.defer_fn(function() require("copilot").setup() end, 100)
  --   end,
  --   requires = {
  --     'zbirenbaum/copilot-cmp',
  --     after = { "copilot.lua", "nvim-cmp" }
  --   },
  -- }

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
      'quangnguyen30192/cmp-nvim-tags',
      'saadparwaiz1/cmp_luasnip',
      'f3fora/cmp-spell',
      'nvim-orgmode/orgmode',
      'ray-x/cmp-treesitter',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'windwp/nvim-autopairs',
    }
  }

  use {
    "amrbashir/nvim-docs-view",
    cmd = { "DocsViewToggle" },
    config = function()
        require("docs-view").setup = {
        position = "right",
        width = 60,
    }
    end
  }

  use { 
    "nkakouros-original/numbers.nvim",
    config = function() require('numbers').setup {
      excluded_filetypes = {
        'alpha',
      }
    }
end
  }

  use { "luukvbaal/nnn.nvim" }

  -- use {
  --   "windwp/nvim-autopairs",
  --   config = function() require("nvim-autopairs").setup {} end
  -- }

  use {
    'declancm/cinnamon.nvim',
    config = function() require('cinnamon').setup {
    extra_keymaps = true,
    extended_keymaps = true,
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

  use { "nvim-orgmode/orgmode",
        require = { 'cmp', 'treesitter' },
    config = function() require('orgmode').setup{} end
  }

  use { "dhruvasagar/vim-table-mode" }

  use {"michaelb/sniprun", run = "bash ./install.sh"}

  use { "lukas-reineke/headlines.nvim",
        config = function() require('headlines').setup() end
      }

  use { "akinsho/org-bullets.nvim",
        config = function() require('org-bullets').setup() end
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

