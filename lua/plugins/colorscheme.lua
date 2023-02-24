local M = { -- colorschemeS;
	{ 'tjdevries/colorbuddy.nvim', lazy = true },
	{ 'rktjmp/lush.nvim', lazy = true },
	-- 'rrethy/nvim-base16',
	{
		'rebelot/kanagawa.nvim',
		lazy = true,
		config = function()
			vim.cmd('colorscheme kanagawa')
		end,
		priority = 1000,
	},
	{
		'noorwachid/nvim-nightsky',
		lazy = true,
		config = function()
			vim.cmd('colorscheme nightsky')
		end,
		priority = 1000,
	},
	{
		'yonlu/omni.vim',
		lazy = true,
		config = function()
			vim.cmd('colorscheme omni')
		end,
		priority = 1000,
	},
	{
		'Yazeed1s/oh-lucy.nvim',
		lazy = true,
		config = function()
			vim.cmd('colorscheme oh-lucy')
		end,
		priority = 1000,
	},
	{
		'christianchiarulli/nvcode-color-schemes.vim',
		lazy = true,
		config = function()
			vim.cmd('colorscheme nvcode')
			vim.cmd {
				[[
        if (has("termguicolors"))
          set termguicolors
          hi LineNr ctermbg=NONE guibg=NONE
          endif
      ]],
			}
		end,
		priority = 1000,
	},
	{
		'jesseleite/nvim-noirbuddy',
		lazy = true,
		config = function()
			require('noirbuddy').setup {
				preset = 'miami-nights',
			}
		end,
		priority = 1000,
	},
	{
		'glepnir/zephyr-nvim',
		lazy = true,
		config = function()
			require('zephyr')
		end,
		priority = 1000,
	},
	-- 'ali-githb/standardized',
	{
		'th3whit3wolf/onebuddy',
		lazy = true,
		config = function()
			require('colorbuddy').colorscheme('onebuddy')
		end,
		priority = 1000,
	},
	{
		'th3whit3wolf/one-nvim',
		lazy = true,
		config = function()
			vim.g.one_nvim_transparent_bg = true, vim.cmd([[ colorscheme one-nvim ]])
		end,
		priority = 1000,
	},
	{
		'ray-x/aurora',
		lazy = true,
		config = function()
			vim.cmd([[ colorscheme aurora ]])
			vim.api.nvim_set_hl(0, 'Normal', { guibg = 'NONE', ctermbg = 'NONE' })
			vim.api.nvim_set_hl(0, 'String', { guibg = '=#339922', ctermbg = 'NONE' })
		end,
		priority = 1000,
	},
	{
		'edeneast/nightfox.nvim',
		lazy = true,
		config = function()
			vim.cmd([[ colorscheme nightfox ]])
		end,
		priority = 1000,
	},
	{
		'navarasu/onedark.nvim',
		lazy = true,
		config = function(style)
			style = style or 'deep'
			require('onedark').setup {
				style = style,
			}
			require('onedark').load()
		end,
		priority = 1000,
	},
	{
		'rafamadriz/neon',
		lazy = false,
		config = function(style)
			style = 'dark'
			vim.g.neon_style = style
			vim.g.neon_transparent = true
			vim.cmd([[colorscheme neon]])
		end,
		priority = 1000,
	},
	-- TODO
	{
		'yagua/nebulous.nvim',
		lazy = true,
		priority = 1000,
		config = function(style)
			style = style or 'night'
			require('nebulous').setup {
				variant = style,
			}
		end,
	},
	{
		'shatur/neovim-ayu',
		lazy = true,
		priority = 1000,
		opts = { mirage = true },
	},
	{
		'ramojus/mellifluous.nvim',
		dependencies = { 'rktjmp/lush.nvim' },
		lazy = true,
		priority = 1000,
		config = function()
			require('mellifluous').setup {}
			vim.cmd('colorscheme mellifluous')
		end,
	},
	{
		'kaiuri/nvim-juliana',
		lazy = true,
		priority = 1000,
		config = function()
			vim.cmd('colorscheme juliana')
		end,
	},
	{
		'projekt0n/github-nvim-theme',
		lazy = true,
		priority = 1000,
		config = function(style)
			style = style or 'dark_default'
			require('github-theme').setup {
				theme_style = style,
			}
		end,
	},
	{
		'kdheepak/monochrome.nvim',
		lazy = true,
		priority = 1000,
		config = function()
			vim.cmd('colorscheme monochrome')
		end,
	},
	{
		'adisen99/codeschool.nvim',
		dependencies = 'rktjmp/lush.nvim',
		lazy = true,
		priority = 1000,
		config = function()
			require('lush')(require('codeschool').setup {})
			vim.g.codeschool_contrast_dark = 'hard'
		end,
	},
	{
		'nyoom-engineering/oxocarbon.nvim',
		lazy = true,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme('oxocarbon')
		end,
	},
	{
		'kvrohit/mellow.nvim',
		lazy = true,
		priority = 1000,
		config = function()
			-- Set Options first
			vim.cmd([[colorscheme mellow]])
		end,
	},
	{
		'kartikp10/noctis.nvim',
		dependencies = 'rktjmp/lush.nvim',
		lazy = true,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme('noctis')
		end,
	},
	{
		'everblush/everblush.nvim',
		lazy = true,
		priority = 1000,
		opts = {
			nvim_tree = { contrast = false },
		},
	},
}

function M.clearbackgrounds()
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

-- function M.config()
-- 	vim.cmd([[ colorscheme kanagawa]])
-- 	-- M.clearbackgrounds()
-- end

-- NVCode colorschemes
-- @param style string onedark|aurora|gruvbox|palenight|nord|snazzy|xoria|nvcode
-- M.nvcode = function(style)
-- 	vim.g.nvcode_termguicolors = 256
-- 	if style == 'onedark' then
-- 		vim.cmd([[colorscheme onedark]])
-- 	elseif style == 'aurora' then
-- 		vim.cmd([[colorscheme aurora]])
-- 	elseif style == 'gruvbox' then
-- 		vim.cmd([[colorscheme gruvbox]])
-- 	elseif style == 'palenight' then
-- 		vim.cmd([[colorscheme palenight]])
-- 	elseif style == 'nord' then
-- 		vim.cmd([[colorscheme nord]])
-- 	elseif style == 'snazzy' then
-- 		vim.cmd([[colorscheme snazzy]])
-- 	elseif style == 'xoria' then
-- 		vim.cmd([[colorscheme xoria]])
-- 	else
-- 		vim.cmd([[colorscheme nvcode]])
-- 	end
-- end

-- M.zephyr = function()
-- 	require('zephyr')
-- end

-- M.onebuddy = function()
-- 	require('colorbuddy').colorscheme('onebuddy')
-- end

-- M.onenvim = function()
-- 	vim.cmd([[colorscheme one-nvim]])
-- end

-- M.noctis = function()
-- 	vim.cmd([[colorscheme noctis]])
-- end

-- M.oxocarbon = function()
-- 	vim.cmd([[colorscheme oxocarbon]])
-- end

-- M.monochrome = function()
-- 	vim.cmd([[colorscheme monochrome]])
-- end

-- M.mellow = function()
-- 	vim.cmd([[colorscheme mellow]])
-- end

-- M.aurora = function()
-- 	vim.g.aurora_transparent = 1
-- 	vim.cmd([[colorscheme aurora]])
-- end

-- M.xresources = function()
-- 	require('xresources')
-- end

-- -- nightfox colorschemes
-- -- @param style string dawnfox|carbonfox|dayfox|duskfox|nordfox|terafox|nightfox
-- M.nightfox = function(style)
-- 	if style == 'dawn' then
-- 		vim.cmd([[colorscheme dawnfox]])
-- 	elseif style == 'carbon' then
-- 		vim.cmd([[colorscheme carbonfox]])
-- 	elseif style == 'day' then
-- 		vim.cmd([[colorscheme dayfox]])
-- 	elseif style == 'dusk' then
-- 		vim.cmd([[colorscheme duskfox]])
-- 	elseif style == 'nord' then
-- 		vim.cmd([[colorscheme nordfox]])
-- 	elseif style == 'tera' then
-- 		vim.cmd([[colorscheme terafox]])
-- 	else
-- 		vim.cmd([[colorscheme nightfox]])
-- 	end
-- end

-- -- onedark colorschemes
-- -- @param style string dark|darker|cool|deep|warm|warmer
-- M.onedark = function(style)
-- 	if style == nil then
-- 		style = 'dark'
-- 	end
-- 	require('onedark').setup {
-- 		style = style,
-- 		transparent = false, -- Show/hide background
-- 		term_colors = true,, -- Change terminal color as per the selected theme style
-- 		ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
-- 		cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

-- 		-- toggle theme style ---
-- 		toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
-- 		toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

-- 		-- Change code style ---
-- 		-- Options are italic, bold, underline, none
-- 		-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
-- 		code_style = {
-- 			comments = 'italic',
-- 			keywords = 'none',
-- 			functions = 'none',
-- 			strings = 'none',
-- 			variables = 'none',
-- 		},

-- 		-- Custom Highlights --
-- 		colors = {}, -- Override default colors
-- 		highlights = {}, -- Override highlight groups

-- 		-- Plugins Config --
-- 		diagnostics = {
-- 			darker = true,, -- darker colors for diagnostic
-- 			undercurl = true,, -- use undercurl instead of underline for diagnostics
-- 			background = true,, -- use background color for virtual text
-- 		},
-- 	}
-- 	require('onedark').load()
-- end

-- -- neon colorschemes
-- -- @param style string default|doom|dark|light
-- M.neon = function(style)
-- 	if style == nil then
-- 		style = 'default'
-- 	end
-- 	vim.g.neon_style = style
-- 	vim.g.neon_italic_comment = true,
-- 	vim.g.neon_italic_keyword = false
-- 	vim.g.neon_italic_boolean = false
-- 	vim.g.neon_italic_function = false
-- 	vim.g.neon_italic_variable = false
-- 	vim.g.neon_bold = false
-- 	vim.g.neon_transparent = false
-- end

-- -- nebulous colorschemes
-- -- @param style string night|twilight|midnight|fullmoon|nova|quasar
-- M.nebulous = function(style)
-- 	if style == nil then
-- 		style = 'night'
-- 	end
-- 	require('nebulous').setup {
-- 		variant = style,
-- 		disable = {
-- 			background = false,
-- 			endOfBuffer = false,
-- 			terminal_colors = false,
-- 		},
-- 		italic = {
-- 			comments = true,, -- default = true,
-- 			keywords = false,
-- 			functions = false,
-- 			variables = false,
-- 		},
-- 		custom_colors = {},
-- 	}
-- end

-- -- ayu colorschemes
-- -- @param style string dark|mirage|light
-- M.ayu = function(style)
-- 	require('ayu').setup {
-- 		overrides = {},
-- 	}
-- 	if style == 'light' then
-- 		vim.cmd([[colorscheme ayu-light]])
-- 	elseif style == 'mirage' then
-- 		vim.cmd([[colorscheme ayu-mirage]])
-- 	else
-- 		vim.cmd([[colorscheme ayu-dark]])
-- 	end
-- end

-- M.icy = function()
-- 	require('lush_theme.icy')
-- end

-- M.everblush = function()
-- 	require('everblush').setup {
-- 		nvim_tree = { contrast = true, },
-- 	}
-- end

-- M.juliana = function()
-- 	vim.cmd([[colorscheme juliana]])
-- end

-- -- github themes colorschemes
-- -- @param style string dark|dimmed|dark_default|dark_colorblind|light|light_default|light_colorblind
-- M.github = function(style)
-- 	if style == nil then
-- 		style = 'default'
-- 	end
-- 	require('github-theme').setup {
-- 		theme_style = style,
-- 		colors = {},
-- 		comment_style = 'italic',
-- 		dark_float = false,
-- 		dark_sidebar = true,,
-- 		dev = false,
-- 		function_style = 'NONE',
-- 		hide_end_of_buffer = true,,
-- 		hide_inactive_statusline = true,,
-- 		keyword_style = 'italic',
-- 		msg_area_style = 'NONE',
-- 		overrides = function()
-- 			return {}
-- 		end,
-- 		sidebars = {},
-- 		transparent = false,
-- 		variable_style = 'NONE',
-- 	}
-- end

return M
