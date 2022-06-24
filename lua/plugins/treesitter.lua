-- nvim-treesitter configuration
local config = require('nvim-treesitter.configs')
require('orgmode').setup_ts_grammar()

config.setup({
  ensure_installed = {
    'css', 'dockerfile', 'html', 'http', 'javascript',
    'json', 'lua', 'python', 'regex', 'ruby', 'rust',
    'yaml', 'markdown', 'bash', 'c', 'cmake', 'comment',
    'cpp', 'go', 'jsdoc', 'json5', 'jsonc', 'llvm', 'make', 'ninja',
    'todotxt', 'toml', 'org',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'org' },
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
      scope_incremental = 'gss'
    },
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags
    max_file_lines = 3000, -- Do not enable for files with more than 3000 lines
    -- colors = {'#d2b48c', '#cd853f', '#ffa500', '#ffd700'}, -- table of hex strings
    -- termcolors = {'White', 'LightYellow', 'Yellow', 'Red'}
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
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
  sync_install = false,
})
-- require "nvim-treesitter.highlight"
-- local hlmap = vim.treesitter.highlighter.hl_map
-- hlmap["punctuation.bracket"] = nil
