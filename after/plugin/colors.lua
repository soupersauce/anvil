local vim = vim
function Colorize(color)
	color = color or 'noctis'
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
	-- vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
	-- vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'none' })
	-- vim.api.nvim_set_hl(0, 'Folded', { bg = 'none' })
	-- vim.api.nvim_set_hl(0, 'ColorColumn', { bg = 'none' })
	-- vim.api.nvim_set_hl(0, 'FloatShadow', { bg = 'none' })
	-- vim.api.nvim_set_hl(0, 'FloatShadowThrough', { bg = 'none' })
	-- vim.api.nvim_set_hl(0, 'ScrollbarHandle', { blend = 50 })
	-- vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'none' })
end

codeschool = function()
	require('lush')(require('codeschool').setup {
		plugins = {
			-- 	'buftabline',
			-- 	'cmp', -- nvim-cmp
			-- 	'fzf',
			-- 'gitsigns',
			-- 	'lsp',
			-- 	'lspsaga',
			-- 	'netrw',
			-- 	'nvimtree',
			-- 'neogit',
			-- 	'packer',
			-- 	'telescope',
			'treesitter',
		},
		langs = {
			'c',
			'clojure',
			'coffeescript',
			'csharp',
			'css',
			'elixir',
			'golang',
			'haskell',
			'html',
			'java',
			'js',
			'json',
			'jsx',
			'lua',
			'markdown',
			'moonscript',
			'objc',
			'ocaml',
			'purescript',
			'python',
			'ruby',
			'rust',
			'scala',
			'typescript',
			'viml',
			'xml',
		},
	})
	vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'Folded', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'ColorColumn', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'FloatShadow', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'FloatShadowThrough', { bg = 'none' })
	vim.api.nvim_set_hl(0, 'ScrollbarHandle', { blend = 50 })
	vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'none' })
end

Colorize()
