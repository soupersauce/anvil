-- Setup nvim-cmp.
local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
  if not snip_status_ok then
    return
end

local pairs_status_ok, cmp_autopairs  = pcall(require, 'nvim-autopairs.completion.cmp')
  if not pairs_status_ok then
   return
end
-- local lspkind = require('lspkind')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line -1, line, true)[1]:sub(col, col):match("%s") == nil
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

require("luasnip/loaders/from_vscode").lazy_load()

cmp.setup {
  cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      ),

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Use LuaSnip.
    end,
  },

  formatting = {
    fields = { "kind", "abbr", "menu"},
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- mode = 'symbol_text',
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[Snip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[LaTeX]",
          path = "[Path]",
          treesitter = "[TS]",
          cmdline = "[:<cmd>]",
          orgmode = "[Org]",
        })[entry.source.name]
      return vim_item
    end,
    maxwidth = 50,
  },

  cmp.setup.cmdline('/', {
    view = {
      entries = {name = 'custom',}
    },
  }),
  view = {
    entries = {name = 'custom', selection_order = 'near_cursor' }
  },

  completion = {
    autocomplete = {
      types.cmp.TriggerEvent.TextChanged,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>']     = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>']     = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-j>']     = cmp.mapping(cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }), { 'i', 'c' }),
    ['<C-k>']     = cmp.mapping(cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<C-e']     = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Super Tab
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s"}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s"}),

  }),
  sources = cmp.config.sources({
    -- { name = "copilot" },
    { name = 'nvim-autopairs.completion.cmp' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'treesitter' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 5 },
    { name = 'cmdline' },
    { name = 'path' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'tmux' },
    { name = 'orgmode' },
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
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
}
