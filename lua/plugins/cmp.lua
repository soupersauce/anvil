-- Setup nvim-cmp.
local cmp = require('cmp')
local luasnip = require('luasnip')
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')


cmp.setup({
  completion = {
    autocomplete = false
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Use LuaSnip.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>']     = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>']     = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>']     = cmp.config.disable, -- Specify `cmp.config.disable` to remove the default mapping.
    -- ['<CR>']      = cmp.event.on( 
    --   'confirm_done',
    --   cmp_autopairs.on_confirm_done()
    -- ),
    ['<C-e>']     = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
  }),
  sources = cmp.config.sources({
    -- { name = "copilot" },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 5 },
    { name = 'orgmode' },
    { name = 'cmp_git' },
  })
})

