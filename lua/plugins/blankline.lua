local present, blankline = pcall(require, 'indent_blankline')

if not present then
	return
end

vim.opt.list = true
vim.opt.listchars:append('space:⋅')
vim.opt.listchars:append('eol:↴')

local options = {
	indentLine_enabled = 1,
	char = '▏',
	filetype_exclude = {
		'help',
		'terminal',
		'alpha',
		'packer',
		'lspinfo',
		'TelescopePrompt',
		'TelescopeResults',
		'lsp-installer',
		'undotree',
		'NeogitStatus',
		'NeogitCommitMessage',
		'NeogitPopup',
		'',
	},
	buftype_exclude = { 'terminal' },
	space_char_blankeline = ' ',
	show_trailing_blankline_indent = false,
	show_first_indent_level = false,
	show_current_context = true,
	show_current_context_start = true,
}

-- options = load_override(options, "lukas-reineke/indent-blankline.nvim")
blankline.setup(options)
