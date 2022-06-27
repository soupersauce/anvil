-- Setup nvim-cmp.
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

local pairs_ok, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
if not pairs_ok then
  return
end
-- local lspkind = require('lspkind')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local types = require('cmp.types')

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
},

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup {
  -- cmp.event:on(
  --       'confirm_done',
  --       cmp_autopairs.on_confirm_done()
  --     ),

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Use LuaSnip.
    end,
  },

  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = require('lspkind').cmp_format({ mode = "symbol_text", maxwidth = 50})(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. strings[1] .. " "
      kind.menu = "   [" .. strings[2] .. "]   "

      return kind
    end,
  },

  cmp.setup.cmdline('/', {
    view = {
      entries = { name = 'custom', }
    },
  }),
  view = {
    entries = { name = 'custom', selection_order = 'near_cursor' }
  },

  completion = {
    autocomplete = {
      types.cmp.TriggerEvent.TextChanged,
    },
    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    col_offset = -3,
    side_padding = 0,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>']     = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>']     = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-j>']     = cmp.mapping(cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
      { 'i', 'c' }),
    ['<C-k>']     = cmp.mapping(cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
      { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<C-e']      = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Super Tab
    ['<Tab>']     = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<S-Tab>']   = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'cmp-zsh' },
    { name = 'orgmode' },
    { name = 'luasnip' },
    { name = 'treesitter' },
    { name = 'cmp_autopairs' },
    { name = 'buffer', keyword_length = 5 },
    { name = 'cmdline' },
    { name = 'cmp_git' },
    { name = 'path' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'tmux' },
    { name = 'tags' },
    { name = 'ctags' },
    { name = 'dictionary', keyword_length = 2 },
    { name = 'spell' },
  }),

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  }),

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  }),

  cmp.setup.filetype('gitcommit', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'cmp_git' }
    }, {
      { name = 'buffer' }
    })
  }),
  -- window = {
  --   completion = cmp.config.window.bordered(),
  --   documentation = cmp.config.window.bordered(),
  -- }
}

require("cmp_dictionary").setup({
  dic = {
    ["*"] = { "/usr/share/dict/words" },
    spelllang = {
      en = "/usr/share/dict/american-english-large",
    },
  }
})
