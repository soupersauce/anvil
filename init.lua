-- Base NeoVim configuration
require('configuration')

-- Only load plugins when not running as root
if vim.fn.exists('$SUDO_USER') == 0 then
	require('plugins')
end
--
-- Configure NeoVim
require('configuration')
-- Specify Highlight groups to use for extracting fg color for
-- statusline components
-- StatusLine:extract_colors {
-- 	Error = 'DiagnosticSignError',
-- 	Warn = 'DiagnosticSignWarn',
-- 	Info = 'DiagnosticSignInfo',
-- 	Hint = 'DiagnosticSignHint',
-- 	Normal = 'Character',
-- 	Insert = 'Question',
-- 	Select = 'Number',
-- 	Replace = 'Label',
-- 	Progress = 'Macro',
-- 	Fileinfo = 'Normal',
-- 	Inactive = 'Conceal',
-- }
