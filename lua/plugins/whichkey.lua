local present, wk = pcall(require, "which-key")

if not present then
   return
end


wk.setup({

--   popup_mappings = {
--      scroll_down = "<c-d>", -- binding to scroll down inside the popup
--      scroll_up = "<c-u>", -- binding to scroll up inside the popup
--   },
--
--   window = {
--      border = "none", -- none/single/double/shadow
--   },
--
--   layout = {
--      spacing = 6, -- spacing between columns
--   },
--
--   hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
--
--   triggers_blacklist = {
--      -- list of mode / prefixes that should never be hooked by WhichKey
--      i = { "j", "k" },
--      v = { "j", "k" },
--   },
})

-- options = require("core.utils").load_override(options, "folke/which-key.nvim")

--local utils = require "core.utils"

----local mappings = utils.load_config().mappings
--local mapping_groups = { groups = vim.deepcopy(mappings.groups) }

--mappings.disabled = nil
--mappings.groups = nil

--utils.load_mappings(mapping_groups)

