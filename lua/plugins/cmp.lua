local vim = vim
local icons = require('icons')
local lspkind = require('lspkind')
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

cmp.setup {
	cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done()),

	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- Use LuaSnip.
		end,
	},

	mapping = cmp.mapping.preset.insert {
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
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
			-- behavior = cmp.ConfirmBehavior.Insert,
			select = false,
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

	completion = {
		autocomplete = {
			types.cmp.TriggerEvent.TextChanged,
		},
		completeopt = 'menu,menuone,noselect',
		keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
		keyword_length = 1,
	},

	sources = cmp.config.sources {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'crates' },
		{ name = 'cmp_autopairs' },
		{ name = 'buffer', keyword_length = 3 },
		{ name = 'path' },
		-- { name = 'treesitter' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'dictionary' },
	},

	formatting = {
		format = lspkind.cmp_format {
			mode = 'symbol_text',
			menu = {
				nvim_lua = '[nvim_api]',
				nvim_lsp = '[lsp]',
				luasnip = '[snip]',
				buffer = '[buf]',
				path = '[path]',
				orgmode = '[org]',
				cmdline = '[:cmd]',
				cmdline_history = '[:hist]',
				cmp_git = '[git]',
				dictionary = '[dict]',
				spell = '[spell]',
			},
		},
		-- 	return vim_item
		-- end,
	},
	cmp.setup.filetype('gitcommit', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources {
			{ name = 'cmp_git' },
			{ name = 'buffer' },
			{ name = 'dictionary' },
		},
	}),

	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'cmdline' },
			{ name = 'path' },
			{ name = 'cmdline_history' },
			{ name = 'buffer' },
		},
		view = {
			entries = { name = 'custom', selection_order = 'near_cursor' },
		},
	}),

	window = {
		winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
		col_offset = -3,
		side_padding = 0,
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
}

require('cmp_dictionary').setup {
	dic = {
		['*'] = { '~/.config/nvim/dictionaries/aspell_en' },
	},
}

for _, cmd_type in ipairs { '/', '?', '@' } do
	cmp.setup.cmdline(cmd_type, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'cmdline_history' },
			{ name = 'buffer' },
		},
		view = {
			entries = { name = 'custom' },
		},
	})
end
