local M = {}
local vim = vim

M.pre = function()
	vim.keymap.set('n', '<F1>', function()
		require('dap').step_back()
	end, { noremap = true, desc = 'DAP Step Back' })
	vim.keymap.set('n', '<F2>', function()
		require('dap').step_into()
	end, { noremap = true, desc = 'DAP Step Into' })
	vim.keymap.set('n', '<F3>', function()
		require('dap').step_over()
	end, { noremap = true, desc = 'DAP Step Over' })
	vim.keymap.set('n', '<F4>', function()
		require('dap').step_out()
	end, { noremap = true, desc = 'DAP Step Out' })
	vim.keymap.set('n', '<F5>', function()
		require('dap').continue()
	end, { noremap = true, desc = 'DAP Continue' })

	vim.keymap.set('n', '<leader>db', function()
		require('dap').toggle_breakpoint()
	end, { noremap = true, desc = 'DAP Toggle Breakpoint' })
	vim.keymap.set('n', '<leader>Db', function()
		require('dap').set_breakpoint(vim.fn.input('[DAP] Condition > '))
	end, { noremap = true, desc = 'DAP Step Out' })
	vim.keymap.set('n', '<leader>dr', function()
		require('dap').repl.open()
	end, { noremap = true, desc = 'DAP Continue' })
end

M.post = function()
	local dap_ok, dap = pcall(require, 'dap')
	if not dap_ok then
		return
	end
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
	vim.fn.sign_define(
		'DapBreakpointCondition',
		{ text = '● ', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' }
	)
	vim.fn.sign_define('DapLogPoint', { text = '● ', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })
	vim.fn.sign_define('DapStopped', { text = '→ ', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
	vim.fn.sign_define('DapBreakpointReject', { text = '●', texthl = 'DiagnosticSignHint', linehl = '', numhl = '' })
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
return {}
