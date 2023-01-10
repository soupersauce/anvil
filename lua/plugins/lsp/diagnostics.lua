local M = {}

M.signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

function M.setup()
	-- Automatically update diagnostics
	vim.diagnostic.config {
		underline = { severity = vim.diagnostic.severity.ERROR },
		update_in_insert = false,
		virtual_text = { spacing = 4, prefix = '●' },
		severity_sort = true,
		signs = { priority = 20 },
	}
	-- Customize how diagnostics are displayed

	-- vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
	--   local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
	--   vim.diagnostic.reset(ns)
	--   return vim.NIL
	-- end

	for type, icon in pairs(M.signs) do
		local hl = 'DiagnosticSign' .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
	end

	vim.lsp.handlers['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if not (client and client.name == 'eslint_d') then
			goto done
		end

		for _, diagnostic in ipairs(result.diagnostics) do
			if diagnostic.message:find('The file does not match your project config') then
				local bufnr = vim.uri_to_bufnr(result.uri)
				eslint_disabled_buffers[bufnr] = true
			end
		end

		::done::
		return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, config)
	end
end

return M
