local util = require('util')

local M = {}

M.autoformat = true

function M.toggle()
	M.autoformat = not M.autoformat
	if M.autoformat then
		util.info('enabled format on save', 'Formatting')
	else
		util.warn('disabled format on save', 'Formatting')
	end
end

function M.setup(client, bufnr)
	local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
	local group = vim.api.nvim_create_augroup('lsp_format_on_save', { clear = false })
	local event = 'BufWritePre' -- or "BufWritePost"
	local async = event == 'BufWritePost'

	if client.supports_method('textDocument/rangeFormatting') then
		-- format on save
		vim.api.nvim_clear_autocmds { buffer = bufnr, group = group }
		vim.api.nvim_create_autocmd(event, {
			buffer = bufnr,
			group = group,
			callback = function()
				vim.lsp.buf.format { bufnr = bufnr, async = async }
			end,
			desc = '[lsp] format on save',
		})
		vim.keymap.set('n', '<leader>tf', function()
			M.toggle()
		end, { desc = 'Toggle Autoformat' })
	end
	-- util.info(
	-- 	client.name .. ' ' .. (client.supports_method('textDocument/rangeFormatting') and 'yes' or 'no'),
	-- 	'format'
	-- )
end
return M
