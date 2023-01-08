local M = {
	'TimUntersberger/neogit',
	cmd = 'Neogit',
}

function M.config()
	local neogit_ok, neogit = pcall(require, 'neogit')

	neogit.setup {
		disable_signs = false,
		disable_hint = false,
		disable_context_highlighting = false,
		disable_commit_confirmation = true,
		-- Neogit refreshes its internal state after specific events,
		-- which can be expensive depending on the repository size.
		-- Disabling `auto_refresh` will make it so you have to manually
		-- refresh the status after you open it.
		auto_refresh = true,
		disable_builtin_notifications = true,
		use_magit_keybindings = false,
		commit_popup = {
			kind = 'split',
		},
		-- Change the default way of opening neogit
		kind = 'replace',
		signs = {
			section = { '▶', '▼' },
			item = { '┗', '┣' },
			hunk = { '┃', '━' },
		},
		integrations = {
			diffview = true,
		},
		mappings = {
			-- modify status buffer mappings
			status = {
				['X'] = 'Discard',
				-- Remove default mapping of 'x'
				['x'] = '',
			},
		},
	}
end
return M
