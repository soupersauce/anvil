-- Statusline configuration
-- inspiration: https://elianiva.my.id/post/neovim-lua-statusline

local M = {}
local fn = vim.fn
local api = vim.api
local vim_cmd = vim.cmd
local listed = fn.buflisted
local get_diagnostics = vim.diagnostic.get
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local hl_by_name = vim.api.nvim_get_hl_by_name

-- TODO: replace with API calls, when available
---@param hl_name name of highlight group
---@param colors map of highlight settings (type to color values)
local create_highlight = function(hl_name, colors)
  local options = {}
  if not colors then return end

  -- build array of all group highlight settings
  for k, v in pairs(colors) do
    table.insert(options, string.format('%s=%s', k, v))
  end

  vim_cmd(string.format('highlight %s %s', hl_name, table.concat(options, " ")))
end


-- retrieve color value of [kind] from highlight group
---@param hl_name name of highlight group
---@param kind type of value to extract (either `background` or `foreground`)
local get_color = function(hl_name, kind)
  local rgb = hl_by_name(hl_name, true)[kind]
  local cterm = hl_by_name(hl_name, false)[kind]
  local hex = (rgb and bit.tohex(rgb, 6) or 'ffffff')
  return { gui = string.format('#%s', hex), cterm = cterm }
end


local palette = {}

-- define highlight groups and build palette from active colorscheme colors
M.build_palette = function()
  local bg      = get_color('StatusLine', 'background')
  local nc      = get_color('StatusLineNC', 'foreground')
  local colors  = {'Red', 'Orange', 'Yellow', 'Green', 'Aqua', 'Blue', 'Purple', 'Normal'}

  palette.Disabled = { ctermfg = nc.cterm, ctermbg = bg.cterm, guifg = nc.gui, guibg = bg.gui }
  palette.Disabled = setmetatable(
    { ctermfg = nc.cterm, ctermbg = bg.cterm, guifg = nc.gui, guibg = bg.gui },
    { __tostring = function() return 'StatusLineDisabled' end }
  )

  for _, color in ipairs(colors) do
    local group_name = 'StatusLine' .. color
    local found, fg = pcall(get_color, color, 'foreground')
    if found then
      local group = setmetatable(
        { ctermfg = fg.cterm, ctermbg = bg.cterm, guifg = fg.gui, guibg = bg.gui },
        { __tostring = function() return group_name end }
      )
      palette[color] = group
      create_highlight(group_name, group)
    end
  end

  -- statusline highlight for inactive buffers
  create_highlight(tostring(palette.Disabled), palette.Disabled)
  -- default highlight for the statusline
  create_highlight('StatusLine', palette.Normal)
  -- configure highlight for wild menu (command mode completions)
  create_highlight('WildMenu', palette.Aqua)

  return palette
end

M.build_palette()

-- Map accent color for statusline based on active mode
local color_map = setmetatable({
  ['n']    = palette.Green,   -- Normal
  ['no']   = palette.Green,   -- Operator pending
  ['v']    = palette.Purple,  -- Visual by character (v)
  ['V']    = palette.Purple,  -- Visual by line (V)
  ['\022'] = palette.Purple,  -- Visual block wise (CTRL-V)
  ['s']    = palette.Purple,  -- Select by character (gh)
  ['S']    = palette.Purple,  -- Select by line (gH)
  ['\019'] = palette.Purple,  -- Select block wise (g CTRL-H)
  ['i']    = palette.Blue,    -- Insert
  ['ic']   = palette.Blue,    -- Insert completion (generic)
  ['ix']   = palette.Blue,    -- Insert completion (CTRL-X)
  ['R']    = palette.Orange,  -- Replace
  ['Rc']   = palette.Orange,  -- Replace completion
  ['Rv']   = palette.Orange,  -- Replace virtual
  ['c']    = palette.Yellow,  -- Command-line
  ['cv']   = palette.Yellow,  -- Execute (gQ)
  ['ce']   = palette.Yellow,  -- Execute (Q)
  ['r']    = palette.Yellow,  -- Prompt for enter
  ['rm']   = palette.Yellow,  -- Read more (-- more -- prompt)
  ['r?']   = palette.Yellow,  -- Prompt yes/no (confirmation prompt)
  ['!']    = palette.Red,     -- Shell execution
  ['t']    = palette.Red,     -- Terminal mode (insert)
  ['nt']   = palette.Green,   -- Terminal mode (normal)
}, {
  __index  = function(_, idx)
    return palette.Green      -- Catch any undefined modes
  end
})

-- Map symbols/text to be used as an identifier for currently active mode
M.mode_map = setmetatable({
  ['n']    = 'N',             -- Normal
  ['no']   = 'N-P',           -- Operator pending
  ['v']    = 'V',             -- Visual by character
  ['V']    = 'V-L',           -- Visual by line
  ['\022'] = 'V-B',           -- Visual block wise, does not work cannot map symbol (^V)
  ['s']    = 'S',             -- Select by character (gh)
  ['S']    = 'S-L',           -- Select by line (gH)
  ['\019'] = 'S-B',           -- Select block wise (g CTRL-H), does not work cannot map symbol (^S)
  ['i']    = 'I',             -- Insert
  ['ic']   = 'I~',            -- Insert completion (generic)
  ['ix']   = 'I~',            -- Insert completion (CTRL-X)
  ['R']    = 'R',             -- Replace
  ['Rc']   = 'R~',            -- Replace completion
  ['Rv']   = 'R-V',           -- Replace virtual
  ['c']    = 'C',             -- Command-line
  ['cv']   = 'C!',            -- Execute (gQ)
  ['ce']   = 'C!',            -- Execute (Q)
  ['r']    = 'P',             -- Prompt for enter
  ['rm']   = 'P!',            -- Read more (-- more -- prompt)
  ['r?']   = 'P?',            -- Prompt yes/no (confirmation prompt)
  ['!']    = 'S',             -- Shell execution
  ['t']    = 'I-T',           -- Terminal mode (insert)
  ['nt']   = 'N-T',           -- Terminal mode (normal)
}, {
  __index  = function(_, mode)
    -- Catch any undefined modes
    return string.format('? (%s)', mode)
  end,
})

-- LSP provided diagnostic error message count
M.format_errors = function()
  local count = #(get_diagnostics(0, { severity = vim.diagnostic.severity.ERROR }))
  return count == 0 and '' or string.format(' E:%s ', count)
end

-- LSP provided diagnostic warning message count
M.format_warnings = function()
  local count = #(get_diagnostics(0, { severity = vim.diagnostic.severity.WARN }))
  return count == 0 and '' or string.format(' W:%s ', count)
end

-- LSP provided diagnostic information message count
M.format_info = function()
  local count = #(get_diagnostics(0, { severity = vim.diagnostic.severity.INFO }))
  return count == 0 and '' or string.format(' I:%s ', count)
end

-- LSP provided diagnostic hints count
M.format_hints = function()
  local count = #(get_diagnostics(0, { severity = vim.diagnostic.severity.HINT }))
  return count == 0 and '' or string.format(' H:%s ', count)
end

-- Language server status and progress messages
M.get_lsp_status = function()
  local clients = vim.lsp.buf_get_clients()
  if (#clients > 0) then
    local client_status = {}

    for _, client in pairs(clients) do
      local messages = {}
      for _token, message in pairs(client.messages.progress) do
        if message.done then
          messages = {}
          break
        elseif message.percentage then
          table.insert(messages, string.format('%s %s', message.title, message.message))
        end
      end
      if #messages > 0 then
        table.insert(client_status, string.format('%s[%s]', client.config.name, messages[1]))
      else
        table.insert(client_status, client.config.name)
      end
    end

    return string.format('(%s) ● ', table.concat(client_status, ' '))
  end

  return "◯ "
end

-- Returns symbolic identifier for current mode
M.get_current_mode = function(self)
  local current_mode = api.nvim_get_mode().mode
  return string.format(' %s ', self.mode_map[current_mode])
end

-- File name with read-only marker or identifier for unsaved changes
M.get_file_state = function()
  local name = fn.expand('%:t')
  local file_name = (name == '' and '[no name]' or name)
  local read_only = "%{&readonly?' -':''}"
  local modified = "%{&modified?' +':''}"
  return string.format(' %s%s%s ', file_name, modified, read_only)
end

-- File's type as identified by neovim.
M.get_file_type = function()
  local file_type = vim.bo.filetype:lower()

  return file_type == ''
    and ' [no ft] '
    or string.format(' %s ', file_type)
end

-- File line ending format Unix / Windows
M.get_file_format = function()
  return string.format('%s ', vim.o.fileformat)
end

-- Character encoding of current file
M.get_file_encoding = function()
  return string.format('%s ', vim.o.encoding)
end

-- Accent color to be applied to statusline based on active mode
M.highlight = function(self, group)
  return string.format('%%#%s#', group)
end

M.get_buffers = function()
  local buffers = api.nvim_list_bufs()
  local current = api.nvim_get_current_buf()
  local prev_bufs = {}
  local next_bufs = {}

  for _, buf in ipairs(buffers) do
    if listed(buf) == 1 then
      if buf < current then
        table.insert(prev_bufs, string.format(' %s ', buf))
      elseif buf > current then
        table.insert(next_bufs, string.format(' %s ', buf))
      end
    end
  end

  return {
    prev_bufs = table.concat(prev_bufs),
    current = string.format(' %s ', current),
    next_bufs = table.concat(next_bufs),
  }
end

-- Statusline to be displayed on active windows
M.set_active = function(self)
  local mode = api.nvim_get_mode().mode
  local accent_color = self:highlight(color_map[mode])
  local buffers = self:get_buffers()

  return table.concat({
    accent_color,
    self:get_current_mode(),
    self:highlight(palette.Aqua),
    self:get_file_state(),
    '%<',                           -- Collapse point for smaller screen sizes
    self:highlight(palette.Disabled),
    buffers.prev_bufs,
    accent_color,
    buffers.current,
    self:highlight(palette.Disabled),
    buffers.next_bufs,
    self:highlight(palette.Red),
    self:format_errors(),
    self:highlight(palette.Orange),
    self:format_warnings(),
    self:highlight(palette.Yellow),
    self:format_info(),
    self:highlight(palette.Blue),
    self:format_hints(),
    '%=',                           -- left / right separator
    self:highlight(palette.Normal),
    self:get_lsp_status(),
    self:get_file_encoding(),
    self:get_file_format(),
    accent_color,
    self:get_file_type(),
    self:highlight(palette.Aqua),
    ' --%1p%%-- ',                  -- Place in file as a percentage
    accent_color,
    ' %l:%c ',                      -- position of cursor
  })
end

-- Statusline to be displayed on inactive windows
M.set_inactive = function(self)
  return table.concat({
    self:highlight(palette.Disabled),
    self:get_file_state(),
    '%=',                           -- left / right separator
    ' --%1p%%-- ',                  -- Place in file as a percentage
    ' %l:%c ',                      -- position of cursor
  })
end

-- Build statusline
StatusLine = setmetatable(M, {
  __call = function(self, mode)
    return self['set_' .. mode](self)
  end,
})

-- Enable StatusLine
-- Calling setup will create required highlight group and add the auto commands
-- for switching between statusline active and inactive variants
M.setup = function()
  StatusLine:build_palette()

  local statusline = augroup("StatusLine", { clear = true })
  -- Rebuild statusline pallet on colorscheme change event
  autocmd("ColorScheme", {
    desc = "rebuild statusline color pallet and highlight groups",
    callback = StatusLine.build_palette,
    group = statusline
  })

  -- Setup autocmds to switch between active and inactive variants when
  -- not using a global status line
  if vim.o.laststatus ~= 3 then
    -- Set statusline to active variant for focused buffer
    autocmd({ "WinEnter", "BufEnter" }, {
      desc = "show active statusline with extra details",
      callback = function() vim.wo.statusline = "%!v:lua.StatusLine('active')" end,
      group = statusline
    })
    -- Set statusline to inactive variant for buffers without focus
    autocmd({ "WinLeave", "BufLeave" }, {
      desc = "show muted statusline without extra details",
      callback = function() vim.wo.statusline = "%!v:lua.StatusLine('inactive')" end,
      group = statusline
    })
  else
    -- Use active varient for global statusline
    vim.o.statusline = "%!v:lua.StatusLine('active')"
  end
end

return StatusLine

