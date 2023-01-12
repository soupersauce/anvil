local M = {}

function M.setup(client, bufnr)
	local vim = vim
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set('n', 'K', function(bufnr)
		local winid = require('ufo').peekFoldedLinesUnderCursor()
		if not winid then
			local filetype = vim.bo.filetype
			if vim.tbl_contains({ 'vim', 'help' }, filetype) then
				vim.cmd('h ' .. vim.fn.expand('<cword>'))
			elseif vim.tbl_contains({ 'man' }, filetype) then
				vim.cmd('Man ' .. vim.fn.expand('<cword>'))
			elseif vim.fn.expand('%:t') == 'Cargo.toml' then
				require('crates').show_popup()
			elseif vim.tbl_contains({ 'rust' }, filetype) then
				require('rust-tools').hover_actions.hover_actions { buffer = bufnr }
			else
				vim.lsp.buf.hover()
			end
		end
	end, { noremap = true, desc = 'Show Documentation' })

	-- Add keybindings for LSP integration
	vim.keymap.set('n', 'gD', function()
		vim.lsp.buf.declaration()
	end, bufopts)

	vim.keymap.set('n', 'gt', function()
		vim.lsp.buf.type_definition()
	end, bufopts)

	-- gr = 'lua vim.lsp.buf.references()',
	vim.keymap.set('n', '<Leader>s', function()
		vim.lsp.buf.document_symbol()
	end, bufopts)

	vim.keymap.set('n', '<Leader>w', function()
		vim.lsp.buf.workspace_symbol()
	end, bufopts)

	vim.keymap.set('n', ']d', function()
		vim.diagnostic.goto_next()
	end, bufopts)

	vim.keymap.set('n', '[d', function()
		vim.diagnostic.goto_prev()
	end, bufopts)

	vim.keymap.set('n', '<leader>rn', function()
		vim.lsp.buf.rename()
	end, bufopts)
	-- ['<leader>ca'] = 'lua vim.lsp.buf.code_action()',
	-- vim.keymap.set('n', '<leader>f', function()
	-- 	vim.lsp.buf.format()
	-- end, bufopts)
	vim.keymap.set('n', '<leader>e', function()
		vim.diagnostic.open_float()
	end, bufopts)
	-- Custom mappings, will overwrite the default mappings for the same key
	vim.keymap.set('n', 'gd', function()
		require('fzf-lua').lsp_definitions()
	end, bufopts)
	vim.keymap.set('n', '<leader>i', function()
		require('fzf-lua').lsp_implementations()
	end, bufopts)
	vim.keymap.set('n', 'gr', function()
		require('fzf-lua').lsp_references()
	end, bufopts)

	vim.keymap.set({ 'v', 'n' }, '<leader>ca', require('actions-preview').code_actions, bufopts)

	if client.supports_method('textDocument/formatting') then
		vim.keymap.set('n', '<Leader>f', function()
			vim.lsp.buf.format { bufnr = vim.api.nvim_get_current_buf() }
		end, { buffer = bufnr, desc = '[lsp] format' })
	end
	if client.supports_method('textDocument/rangeFormatting') then
		vim.keymap.set('x', '<Leader>f', function()
			vim.lsp.buf.format { bufnr = vim.api.nvim_get_current_buf() }
		end, { buffer = bufnr, desc = '[lsp] format' })
	end
end
return M
