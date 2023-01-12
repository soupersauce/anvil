local M = {
	{ -- DAP:
		'mfussenegger/nvim-dap',
    cond = vim.g.started_by_firenvim == nil,
		enabled = false,
		setup = function()
			require('plugins.dap').pre()
		end,
		-- config = function()
		-- 	require('plugins.dap').post()
		-- end,
	},
	'theHamsta/nvim-dap-virtual-text',
	'rcarriga/nvim-dap-ui',
	'leoluz/nvim-dap-go',
	'mfussenegger/nvim-dap-python',
	'jbyuki/one-small-step-for-vimkind',
	'nvim-telescope/telescope-dap.nvim',
}
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

-- function M.dapui.config()
-- 	local dap = require('dap')
-- 	local dapui = require('dapui')

-- 	dap.listeners.after.event_initialized['dapui_config'] = dapui.open
-- 	dap.listeners.before.event_terminated['dapui_config'] = dapui.close
-- 	dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- 	dapui.setup {
-- 		icons = { expanded = '▼', collapsed = '▶' },
-- 		mappings = {
-- 			expand = { '<CR>', '<2-LeftMouse>' },
-- 			open = 'o',
-- 			remove = 'd',
-- 			edit = 'e',
-- 			repl = 'r',
-- 			toggle = 't',
-- 		},
-- 		-- Expand lines larger than the window - Requires >= 0.7
-- 		expand_lines = vim.fn.has('nvim-0.7'),
-- 		layouts = {
-- 			{
-- 				elements = {
-- 					-- table of ids:string or table of tables( id: string, size:(float | integer > 1) ))
-- 					{ id = 'scopes', size = 0.35 },
-- 					{ id = 'breakpoints', size = 0.10 },
-- 					{ id = 'stacks', size = 0.35 },
-- 					{ id = 'watches', size = 0.20 },
-- 				},
-- 				size = 40,
-- 				position = 'left', -- Can be 'left', 'right', 'top', 'bottom'
-- 			},
-- 			{
-- 				elements = { 'repl', 'console' },
-- 				size = 10,
-- 				position = 'bottom', -- Can be 'left', 'right', 'top', 'bottom'
-- 			},
-- 		},
-- 		floating = {
-- 			border = 'single', -- Border style. Can be 'single', 'double' or 'rounded'
-- 			mappings = {
-- 				close = { 'q', '<Esc>' },
-- 			},
-- 		},
-- 		windows = { indent = 1 },
-- 		render = {
-- 			max_type_length = nil, -- Can be integer or nil.
-- 		},
-- 	}
-- end
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
