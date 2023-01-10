local M = { -- URLView
  {
    'axieax/urlview.nvim',
    cmd = 'UrlView',
    keys = {
      { '<leader>L', '<cmd>UrlView<CR>', { desc = 'Buffer URLs' } },
      { '<leader>ll', '<cmd>UrlView lazy<CR>', { desc = 'Lazy URLs' } },
    },
    opts = {
      default_action = 'system',
      sorted = 'false',
    },
  },
}

return M
