local vim = vim
local set_keymap = vim.keymap.set
local options = { noremap = true }

-- Set leader key
vim.g.mapleader = ' '
-- Use CTRL + j/k for fast scroll
set_keymap('n', '<C-k>', '<C-u>', { noremap = true })
set_keymap('n', '<C-j>', '<C-d>', { noremap = true })

-- Paste from & copy to system clipboard
set_keymap('', ',p', '"+p', options)
set_keymap('v', ',y', '"+y', options)
set_keymap('n', ',y', '"+y', options)
-- Yank current line to system clipboard
set_keymap('n', ',yy', '"+yy', options)

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

-- Write changes made to open files
set_keymap('n', ',w', ':w<CR>', { noremap = true })
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

-- Use <Leader><Esc> to exit insert mode in terminal buffers
-- set_keymap('t', '<Leader><C-[>', '<C-\\><C-n>', { noremap = true, silent = true })

-- For nvim-tree
set_keymap('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { noremap = true, desc = 'Toggle NvimTree' })

set_keymap('n', '<leader>ws', '<cmd>w<CR><cmd>source %<CR>', { noremap = true })

vim.keymap.set('n', '<leader>u', function()
	require('undotree').toggle()
end, { noremap = true, desc = 'Toggle UndoTree', silent = false })
