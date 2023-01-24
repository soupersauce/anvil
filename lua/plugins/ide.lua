local M = {
	-- LSPKIND:
	'onsails/lspkind.nvim',
	{ -- BLANKLINE:
		'lukas-reineke/indent-blankline.nvim',
		init = function()
			vim.opt.list = true
			vim.opt.listchars:append('space:⋅')
			vim.opt.listchars:append('multispace: ')
			vim.opt.listchars:append('lead: ')
			vim.opt.listchars:append('eol:↴')
		end,
		opts = {
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
		},
	},
	{ -- UFO:
		'kevinhwang91/nvim-ufo',
		-- cond = vim.g.started_by_firenvim == nil,
		dependencies = 'kevinhwang91/promise-async',
		keys = {
			{
				'zR',
				function()
					require('ufo').openAllFolds()
				end,
				desc = 'UfoOpenAll',
			},
			{
				'zM',
				function()
					require('ufo').closeAllFolds()
				end,
				desc = 'UfoCloseAll',
			},
			{
				'zr',
				function()
					require('ufo').openFoldsExceptKinds()
				end,
				desc = 'UfoOpenExcept',
			},
			{
				'zm',
				function()
					require('ufo').closeFoldsWith()
				end,
				desc = 'UfoCloseWith',
			}, -- closeAllFolds == closeFoldsWith(0)
		},
		config = function()
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ('  %d '):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, 'MoreMsg' })
				return newVirtText
			end

			-- If you disable this autocmd and some folds in org files won't close
			-- This is why. TODO: see if we can make it work?
			vim.api.nvim_create_autocmd({ 'FileType' }, {
				pattern = { 'org' },
				callback = function()
					require('ufo').detach()
				end,
			})

			require('ufo').setup {
				provider_selector = function(bufnr, filetype, buftype)
					return { 'lsp', 'indent' }
				end,
				fold_virt_text_handler = handler,
			}
		end,
	},
	{ -- WEB-DEVICONS:
		'kyazdani42/nvim-web-devicons',
		opts = { default = true },
	},
	{
		'numToStr/Comment.nvim',
		cond = vim.g.started_by_firenvim == nil,
		dependencies = 'joosepalviste/nvim-ts-context-commentstring',
		opts = {
			hook = function()
				require('ts_context_commentstring.internal').update_commentstring()
			end,
			-- pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),

			ignore = '^$',
		},
	},
	{
		'windwp/nvim-autopairs',
		config = function()
			local autopairs = require('nvim-autopairs')
			local Rule = require('nvim-autopairs.rule')

			require('nvim-autopairs').setup {
				fast_wrap = {
					map = '<M-e>',
					chars = { '{', '[', '(', '"', "'" },
					pattern = [=[[%'%"%)%>%]%)%}%,]]=],
					end_key = '$',
					keys = 'qwertyuiopzxcvbnmasdfghjkl',
					check_comma = true,
					highlight = 'Search',
					highlight_grey = 'Comment',
				},
				check_ts = true,
				disable_filetype = { 'alpha', 'vim', 'NvimTree', 'TelescopePrompt' },
				ts_config = {
					javascript = { 'template_string' },
					java = false,
					rust = {},
				},
			}

			local ts_conds = require('nvim-autopairs.ts-conds')
			local cond = require('nvim-autopairs.conds')

			autopairs.add_rules {
				Rule('%', '%', 'lua'):with_pair(ts_conds.is_ts_node { 'string', 'comment' }),
				Rule('$', '$', 'lua'):with_pair(ts_conds.is_ts_node { 'function' }),
				-- Add padding when space entered after opening pair
				Rule(' ', ' '):with_pair(function(opts)
					local pair = opts.line:sub(opts.col - 1, opts.col)
					return vim.tbl_contains({ '()', '[]', '{}' }, pair)
				end),
				Rule('( ', ' )')
					:with_pair(function()
						return false
					end)
					:with_move(function(opts)
						return opts.prev_char:match('.%)') ~= nil
					end)
					:use_key(')'),
				Rule('{ ', ' }')
					:with_pair(function()
						return false
					end)
					:with_move(function(opts)
						return opts.prev_char:match('.%}') ~= nil
					end)
					:use_key('{'),
				Rule('[ ', ' ]')
					:with_pair(function()
						return false
					end)
					:with_move(function(opts)
						return opts.prev_char:match('.%]') ~= nil
					end)
					:use_key('['),
			}
		end,
	},
}

return M
