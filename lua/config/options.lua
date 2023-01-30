local fn = vim.fn
local global_options = vim.o

-- Prefer dark background
vim.o.background = 'dark'

-- Set default shell
vim.o.shell = 'zsh'

-- Restrict existing tab to width of 4 spaces
vim.o.tabstop = 2

-- Use 4 spaces for tabs
vim.o.shiftwidth = 2

-- Always expand tabs to spaces
vim.o.expandtab = true

-- Absolute line numbers. Should be commented out if relativenumber is used
vim.o.number = true

-- Start with relative line numbers 'nkakouros-original/numbers.nvim" should hand from there
-- Should be commented out if number is used
-- vim.o.relativenumber = true

-- Set minimum width for line numbers
vim.o.numberwidth = 3

-- Highlight line containing the cursor
vim.o.cursorline = true

vim.o.colorcolumn = 80

-- But only the visual line, not the complete physical line
-- vim.o.cursorlineopt  = "screenline"

-- Enable mouse interaction
vim.o.mouse = 'a'

-- Use English dictionary
vim.o.spell = false
vim.o.spelllang = 'en_us'

-- Hide buffers with unsaved changes without being prompted
vim.o.hidden = true

-- Auto-complete on tab, while in command mode
vim.o.wildmenu = true

-- Ignore case when completing in command mode
vim.o.wildignorecase = true

-- Do not use popup menu for completions in command mode
vim.o.wildoptions = 'pum'

-- Stop popup menu messages
vim.o.shortmess = 'aoOstcIFC'

-- Use interactive replace
vim.o.inccommand = 'split'

-- Use interactive search
vim.o.incsearch = true

-- Don"t update screen while macro or command/script is executing
vim.o.lazyredraw = false

-- Use global status line
vim.o.laststatus = 3

-- Don"t show mode as it is already displayrd in status line
vim.o.showmode = false

-- Minimum number of lines to keep before scrolling
vim.o.scrolloff = 6

-- Max number of items visible in popup menu
vim.o.pumheight = 15

-- Trigger CursorHold event if nothing is typed for the duration
vim.o.updatetime = 1000

-- Settings for better diffs
vim.o.diffopt = 'filler,vertical,hiddenoff,foldcolumn:1,algorithm:patience'

-- Show whitespace characters
vim.o.list = true

-- Only show tabs and trailing spaces
vim.o.listchars = 'tab: ,trail:●,extends:◣,precedes:◢'

-- Default search is not case sensitive
vim.o.ignorecase = true

-- Search will be case sensitive if uppercase character is entered
vim.o.smartcase = true

-- Automatically Read changes made to file outside of Vim
vim.o.autoread = true

-- Don"t wrap long lines
vim.o.wrap = false

-- Tell neovim where to look for tags file
vim.o.tags = '/tmp/tags'

-- Number of columns to scroll horizontally when cursor is moved off the screen
vim.o.sidescroll = 5

-- Minimum number of columns to keep towards the right of the cursor
vim.o.sidescrolloff = 5

-- Status area size

vim.o.cmdheight = 2
-- Modelines
vim.o.modeline = true
-- Show sign column inside the number column
vim.o.signcolumn = 'yes:1'
-- Opens all folds by default, folding still enabled
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldcolumn = '1'
vim.o.fillchars = [[vert:▕,horiz:─,eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.o.statuscolumn = '%=%l%s%C'
vim.o.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s%C"
vim.o.conceallevel = 2
vim.o.concealcursor = 'nc'

-- Direction window splits open
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.splitkeep = 'screen'
-- Enable true colors if supported
if fn.has('termguicolors') then
  vim.o.termguicolors = true
end

vim.o.clipboard = 'unnamed'

-- Undo file settings
if fn.has('persistent_undo') then
  vim.o.undodir = fn.stdpath('state') .. '/undodir/'
  vim.o.undofile = true
end

-- Disable some features when running as Root
if fn.exists('$SUDO_USER') ~= 0 then
  vim.o.swapfile = false
  vim.o.backup = false
  vim.o.writebackup = false
  vim.o.undofile = false
  vim.o.viminfo = nil
  vim.o.foldenable = false
end

if vim.g.started_by_firenvim then
  vim.o.cmdheight = 0
  -- Modelines
  vim.o.modeline = false
  vim.o.laststatus = '0'
  -- Show sign column inside the number column
  vim.o.signcolumn = 'no'
  vim.o.foldcolumn = '0'
end

-- Use ripgrep as the grep program, if available
if fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

-- Set zsh as default shell, if available
if fn.executable('zsh') == 1 then
  vim.o.shell = 'zsh'
end

vim.o.foldoptions = 'nodigits'
-- Enable highlighting embedded lua code
vim.g.vimsyn_embed = 'l'
-- Use Python 3 for plugins
vim.g.python3_host_prog = 'python3'
