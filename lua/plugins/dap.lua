local dap_ok, dap = pcall(require, 'dap')
if not dap_ok then
	return
end

-- dap-install configurations
-- local dap_install = require("dap-install")
-- dap_install.setup({
--   installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
-- })
-- local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

-- for _, debugger in ipairs(dbg_list) do
--   dap_install.config(debugger)
-- end
dap.configurations.lua = {
	{
		type = 'nlua',
		request = 'attach',
		name = 'Attach to running Neovim instance',
		host = function()
			local value = vim.fn.input('Host [127.0.0.1]: ')
			if value ~= '' then
				return value
			end
			return '127.0.0.1'
		end,
		port = function()
			local val = tonumber(vim.fn.input('Port: '))
			assert(val, 'Please provide a port number')
			return val
		end,
	},
}

dap.adapters.nlua = function(callback, config)
	callback { type = 'server', host = config.host, port = config.port }
end

dap.defaults.fallback.terminal_win_cmd = 'ToggleTerm'
vim.fn.sign_define('DapBreakpoint', { text = '● ', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '● ', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '● ', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '→ ', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointReject', { text = '●', texthl = 'DiagnosticSignHint', linehl = '', numhl = '' })
