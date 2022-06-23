local pairs_ok, npairs = pcall('require','nvim-autopairs')
local cmp_ok, cmp = pcall('require','cmp')
local Rule = require('nvim-autopairs.rule')

if not (pairs_ok and cmp_ok) then
  return
end

npairs.setup({
  fast_wrap = {},
  check_ts = true,
  disable_filetype = { "alpha", "vim", "NvimTree"},
  ts_config = {
    lua = {'string'},
    javascript = {'template_string'},
    java = false,
  }
})

local ts_conds = require('nvim-autopairs.ts-conds')

npairs.add_rules({
  Rule("%", "%", "lua")
    :with_pair(ts_conds.is_ts_node({'string', 'comment'})),
  Rule("$", "$", "lua")
    :with_pair(ts_conds.is_ts_node({'function'})),
  -- Add padding when space entered after opening pair
  Rule(" ", " ")
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule("( ", " )")
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%)') ~= nil
    end)
    :use_key(')'),
  Rule("{ ", " }")
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%}') ~= nil
    end)
    :use_key('{'),
  Rule("[ ", " ]")
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%]') ~= nil
    end)
    :use_key('['),
})

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
cmp.event:on("confirm_done", cmp.autopairs.on_confirm_done())
