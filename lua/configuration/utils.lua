local M = {}

local vim = vim

M.table = {
  some = function(tbl, cb)
    for k, v in ipairs(tbl) do
      if cb(k, v) then
        return true
      end
    end
    return false
  end,
}

M.buf_command = function(bufnr, name, fn, opts)
  vim.api.nvim_buf_create_user_command(bufnr, name, fn, opts or {})
end

return M
