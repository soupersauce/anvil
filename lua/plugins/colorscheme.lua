local vim = vim
local M = {}

M.init = function()
	M.nebulous()
end

-- NVCode colorschemes
-- @param style string available options onedark|aurora|gruvbox|palenight|nord|snazzy|xoria|nvcode
M.nvcode = function(style)
	vim.g.nvcode_termguicolors = 256
	if style == 'onedark' then
		vim.cmd([[colorscheme onedark]])
	elseif style == 'aurora' then
		vim.cmd([[colorscheme aurora]])
	elseif style == 'gruvbox' then
		vim.cmd([[colorscheme gruvbox]])
	elseif style == 'palenight' then
		vim.cmd([[colorscheme palenight]])
	elseif style == 'nord' then
		vim.cmd([[colorscheme nord]])
	elseif style == 'snazzy' then
		vim.cmd([[colorscheme snazzy]])
	elseif style == 'xoria' then
		vim.cmd([[colorscheme xoria]])
	else
		vim.cmd([[colorscheme nvcode]])
	end
end

M.zephyr = function()
	local _, zephyr = pcall(require, 'zephyr')
end

M.onebuddy = function()
	require('colorbuddy').colorscheme('onebuddy')
end

M.onenvim = function()
	vim.cmd([[colorscheme one-nvim]])
end

M.monochrome = function()
	vim.cmd([[colorscheme monochrome]])
end

M.aurora = function()
	vim.g.aurora_transparent = 1
	vim.cmd([[colorscheme aurora]])
end

M.xresources = function()
	require('xresources')
end

M.nightfox = function(style)
	if style == 'dawn' then
		vim.cmd([[colorscheme dawnfox]])
	elseif style == 'carbon' then
		vim.cmd([[colorscheme carbonfox]])
	elseif style == 'day' then
		vim.cmd([[colorscheme dayfox]])
	elseif style == 'dusk' then
		vim.cmd([[colorscheme duskfox]])
	elseif style == 'nord' then
		vim.cmd([[colorscheme nordfox]])
	elseif style == 'tera' then
		vim.cmd([[colorscheme terafox]])
	else
		vim.cmd([[colorscheme nightfox]])
	end
end

M.onedark = function(style)
	require('onedark').setup {
		style = style,
	}
	require('onedark').load()
end

M.neon = function(style)
	if style == nil then
		style = 'default'
	end
	vim.g.neon_style = style
end

M.nebulous = function(style)
	if style == nil then
		style = 'night'
	end
	require('nebulous').setup {
		variant = style,
	}
end

M.ayu = function(style)
	require('ayu').setup {}
	if style == 'light' then
		vim.cmd([[colorscheme ayu-light]])
	elseif style == 'dark' then
		vim.cmd([[colorscheme ayu-dark]])
	else
		vim.cmd([[colorscheme ayu-mirage]])
	end
end

M.icy = function()
	require('lush_theme.icy')
end

M.everblush = function()
	require('everblush').setup {
		nvim_tree = { contrast = true },
	}
end

M.juliana = function()
	vim.cmd([[colorscheme juliana]])
end

M.github = function(style)
	if style == nil then
		style = 'default'
	end
	require('github-theme').setup {
		theme_style = style,
	}
end

M.codeschool = function()
	require('lush')(require('codeschool').setup {
		plugins = {
			'buftabline',
			'cmp', -- nvim-cmp
			'fzf',
			'gitsigns',
			'lsp',
			'lspsaga',
			'netrw',
			'nvimtree',
			'neogit',
			'packer',
			'telescope',
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
end

return M
