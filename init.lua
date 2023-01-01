vim = vim

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local _, impatient = pcall(require, 'impatient')

-- Configure NeoVim
require('config.options')
-- Only load plugins when not running as root
if vim.fn.exists('$SUDO_USER') == 0 then
	require('config.lazy')
	require('config.plugins')
end
--
