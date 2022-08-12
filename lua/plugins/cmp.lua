local vim = vim
local icons = require('icons')
-- Setup nvim-cmp.
local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, 'luasnip')
if not snip_status_ok then
	return
end

local pairs_ok, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
if not pairs_ok then
	return
end

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local types = require('cmp.types')

local box_icons =
	{
		Text = '',
		Method = '',
		Function = '',
		Constructor = '',
		Field = '',
		Variable = '',
		Class = '',
		Interface = '',
		Module = '',
		Property = '',
		Unit = '',
		Value = '',
		Enum = '',
		Keyword = '',
		Snippet = '',
		Color = '',
		File = '',
		Reference = '',
		Folder = '',
		EnumMember = '',
		Constant = '',
		Struct = '',
		Event = '',
		Operator = '',
		TypeParameter = '',
	}, require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup {
	-- cmp.event:on(
	--       'confirm_done',
	--       cmp_autopairs.on_confirm_done()
	--     ),

	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- Use LuaSnip.
		end,
	},

	cmp.setup.cmdline('/', {
		view = {
			entries = { name = 'custom' },
		},
	}),
	view = {
		entries = { name = 'custom', selection_order = 'near_cursor' },
	},

	completion = {
		autocomplete = {
			types.cmp.TriggerEvent.TextChanged,
		},
		winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
		col_offset = -3,
		side_padding = 0,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-j>'] = cmp.mapping(
			cmp.mapping.select_next_item { behavior = types.cmp.SelectBehavior.Select },
			{ 'i', 'c' }
		),
		['<C-k>'] = cmp.mapping(
			cmp.mapping.select_prev_item { behavior = types.cmp.SelectBehavior.Select },
			{ 'i', 'c' }
		),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		},
		['<C-e'] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		},
		-- Super Tab
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = cmp.config.sources {
		{ name = 'nvim_lsp' },
		{ name = 'path' },
		{ name = 'orgmode' },
		{ name = 'luasnip' },
		{ name = 'buffer', keyword_length = 5 },
		{ name = 'cmdline' },
		{ name = 'nvim_lua' },
		{ name = 'cmp-zsh' },
		-- { name = 'treesitter' },
		{ name = 'cmp_autopairs' },
		{ name = 'cmp_git' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'tmux' },
		{ name = 'tags' },
		{ name = 'ctags' },
		{ name = 'dictionary', keyword_length = 2 },
		{ name = 'spell' },
	},

	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = string.format('%s %s', icons.kind_icons[vim_item.kind], vim_item.kind)
			vim_item.menu = ({
				nvim_lsp = '[lsp]',
				luasnip = '[snip]',
				buffer = '[buf]',
				path = '[path]',
				nvim_lua = '[nvim_api]',
				orgmode = '[org]',
				cmdline = '[:cmd]',
				cmp_git = '[git]',
				dictionary = '[dict]',
				spell = '[spell]',
			})[entry.source.name]
			return vim_item
		end,
	},

	cmp.setup.cmdline('/', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' },
		},
	}),

	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' },
		}, {
			{ name = 'cmdline' },
		}),
	}),

	cmp.setup.filetype('gitcommit', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'cmp_git' },
		}, {
			{ name = 'buffer' },
		}),
	}),
	window = {
		-- completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
}

require('cmp_dictionary').setup {
	dic = {
		['*'] = { '/usr/share/dict/words' },
		spelllang = {
			en = '/usr/share/dict/american-english-large',
		},
	},
}
