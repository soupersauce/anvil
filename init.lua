vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.loader.enable()

-- local _, impatient = pcall(require, 'impatient')
-- Configure NeoVim
require('config')
-- Only load plugins when not running as root
if vim.fn.exists('$SUDO_USER') == 0 then
	require('config.lazy')
	require('plugins')
end
