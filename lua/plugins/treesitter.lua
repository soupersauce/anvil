-- nvim-treesitter configuration
local config = require('nvim-treesitter.configs')
require('orgmode').setup_ts_grammar()

vim.o.foldmethod  = 'expr'
vim.o.foldexpr    = 'nvim_treesitter#foldexpr()'

config.setup({
  ensure_installed = {
    'css', 'dockerfile', 'elixir', 'erlang', 'fish', 'html', 'http', 'javascript',
    'json', 'lua', 'php', 'python', 'regex', 'ruby', 'rust', 'scss', 'svelte',
    'typescript', 'vue', 'yaml', 'markdown', 'bash', 'c', 'cmake', 'comment',
    'cpp', 'dart', 'go', 'jsdoc', 'json5', 'jsonc', 'llvm', 'make', 'ninja',
    'prisma', 'proto', 'pug', 'swift', 'todotxt', 'toml', 'tsx', 'org',
  },
  highlight = {
    additional_vim_regex_highlighting = {'org'},
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
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  indent = {
    enable = true,
  },
  sync_install = false,
})
