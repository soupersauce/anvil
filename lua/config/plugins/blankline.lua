local M = { -- INDENT-BLANKLINE
	'lukas-reineke/indent-blankline.nvim',
}

function M.config()
	local _, blankline = pcall(require, 'indent_blankline')

	vim.opt.list = true
	vim.opt.listchars:append('space:⋅')
	vim.opt.listchars:append('eol:↴')

	local options = {
		indentLine_enabled = true,
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
			'lazy',
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
end

return M
