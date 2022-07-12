local set_keymap = vim.keymap.set
local options = { noremap = true }

-- Set leader key
vim.g.mapleader = ' '

-- Use CTRL + j/k for fast scroll
-- TODO: We might remap these to window navigation
-- Dont have a problem with <C-f>,<C-b> for navgation
set_keymap('n', '<C-k>', '<C-u>', { noremap = true })
set_keymap('n', '<C-j>', '<C-d>', { noremap = true })
-- Trim trailing whitespace
set_keymap('n', ',s', ':%s/\\s\\+$//e<CR>')
-- Delete current buffer, (keep window splits)
set_keymap('n', 'bd', ':bd<CR>', options)
-- Use ALT + q/l for opening quickfix and loclist
set_keymap('n', '<A-q>', ':cope<CR>', options)
set_keymap('n', '<A-l>', ':cope<CR>', options)
-- Close Quickfix list
set_keymap('n', ']Q', ':cla<CR>', options)
-- Close Location list
set_keymap('n', ',l', ':lcl<CR>', options)
-- Fast * list navigation, inspired by tpope/vim-unimpaired
-- [ / ] -> previous / next, Uppercase Modifier -> First / Last
-- Quickfix list navigation:
set_keymap('n', ',q', ':ccl<CR>', options)
set_keymap('n', '[q', ':cpr<CR>', options)
set_keymap('n', ']q', ':cnex<CR>', options)
set_keymap('n', '[Q', ':cfir<CR>', options)
-- Location list navigation
set_keymap('n', '[l', ':lpr<CR>', options)
set_keymap('n', ']l', ':lne<CR>', options)
set_keymap('n', '[L', ':lfir<CR>', options)
set_keymap('n', ']L', ':lla<CR>', options)
-- Buffer list navigation
set_keymap('n', '[b', ':bp<CR>', options)
set_keymap('n', ']b', ':bn<CR>', options)
set_keymap('n', '[B', ':bf<CR>', options)
set_keymap('n', ']B', ':bl<CR>', options)

-- Yank current line to system clipboard
set_keymap('n', ',y', '+yy', options)
-- Close current window
-- set_keymap('n', ',c', ':q<CR>', { noremap = true })
-- Write changes made to open files
-- set_keymap('n', ',w', ':w<CR>', { noremap = true })
set_keymap('n', '<leader>w', ':wa<CR>', { noremap = true })

-- Use alt modifier for scrolling buffer
set_keymap('', '<A-j>', '<C-e>', { noremap = true })
set_keymap('', '<A-k>', '<C-y>', { noremap = true })

-- Move vertically by visual line
set_keymap('n', 'j', 'gj', options)
set_keymap('n', 'k', 'gk', options)

-- Keep cursor inplace while joining lines
set_keymap('n', 'J', 'mzJ`z', options)

-- Close popup menu and compensate cursor shifting one place left
-- Use Shift + J/K to moves selected lines up/down in visual mode
set_keymap('v', 'J', ":m '>+1<CR>gv=gv", options)
set_keymap('v', 'K', ":m '<-2<CR>gv=gv", options)

-- Keep current search result centered on the screen
set_keymap('n', 'n', 'nzz', options)
set_keymap('n', 'N', 'Nzz', options)

-- Keep current cursor position while entering and exiting insert mode
set_keymap('i', '<Esc>', function()
	return vim.fn.pumvisible() == 1 and '<Esc>i<Right>' or '<Right><Esc>'
end, { noremap = true, expr = true })

-- Keep visual selected after indent
set_keymap('v', '<', '<gv', { noremap = true })
set_keymap('v', '>', '>gv', { noremap = true })

-- Use <C-w> to move between terminal buffer and other buffers
-- set_keymap('t', '<C-w>', '<C-\\><C-n><C-w>', { noremap = true })

-- Use <Leader><Esc> to exit insert mode in terminal buffers
-- set_keymap('t', '<Leader><C-[>', '<C-\\><C-n>', { noremap = true, silent = true })

-- -- For knap
-- F5 processes the document once, and refreshes the view
set_keymap({ 'n', 'v', 'i' }, '<F5>', function()
	require('knap').process_once()
end, { desc = 'Knap: Process once/Refresh View' })
-- F6 closes the viewer application, and allows settings to be reset
set_keymap({ 'n', 'v', 'i' }, '<F6>', function()
	require('knap').close_viewer()
end, { desc = 'Knap: Close viewer' })
-- F7 toggles the auto-processing on and off
set_keymap({ 'n', 'v', 'i' }, '<F7>', function()
	require('knap').toggle_autopreviewing()
end, { desc = 'Knap: Toggle auto processing' })
-- F8 invokes a SyncTeX forward search, or similar, where appropriate
set_keymap({ 'n', 'v', 'i' }, '<F8>', function()
	require('knap').forward_jump()
end, { desc = 'Knap: SyncTex forward search' })

-- -- For fzf-lua
set_keymap({ 'v', 'n' }, '<leader>zb', function()
	require('fzf-lua').buffers()
end, { desc = 'Fzf: Buffers' })
set_keymap({ 'v', 'n' }, '<leader>zf', function()
	require('fzf-lua').git_files()
end, { desc = 'Fzf: Files' })
set_keymap({ 'v', 'n' }, '<leader>zg', function()
	require('fzf-lua').live_grep()
end, { desc = 'Fzf: Grep' })
set_keymap({ 'v', 'n' }, '<leader>zt', function()
	require('fzf-lua').tags()
end, { desc = 'Fzf: Tags' })
set_keymap({ 'v', 'n' }, '<leader>zc', function()
	require('fzf-lua').git_commits()
end, { desc = 'Fzf: Commits' })
set_keymap({ 'v', 'n' }, '<leader>zm', function()
	require('fzf-lua').man_pages()
end, { desc = 'Fzf: manpages' })
set_keymap({ 'v', 'n' }, '<leader>zr', function()
	require('fzf-lua').lsp_references()
end, { desc = 'Fzf: References' })
set_keymap({ 'v', 'n' }, '<leader>zs', function()
	require('fzf-lua').lsp_definitions()
end, { desc = 'Fzf: definitions' })
set_keymap({ 'v', 'n' }, '<leader>zh', function()
	require('fzf-lua').help_tags()
end, { desc = 'Fzf: help tags' })
set_keymap({ 'v', 'n' }, '<leader>zv', function()
	require('fzf-lua').command_history()
end, { desc = 'Fzf: cmd history' })
set_keymap({ 'v', 'n' }, '<C-p>', function()
	require('fzf-lua').builtin()
end, { desc = 'Fzf: default' })
-- For nvim-tree
set_keymap('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { noremap = true, desc = 'Toggle NvimTree' })

set_keymap('n', '<leader>ws', '<cmd>w<CR><cmd>source %<CR>', { noremap = true })
