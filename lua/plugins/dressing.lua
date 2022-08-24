local dressing_ok, dressing = pcall(require, 'dressing')
-- local code_action_menu = require('code_action_menu')

if not dressing_ok then
	print('No Dressing')
	return
end

dressing.setup {
	select = {
		backend = { 'nui', 'fzf_lua', 'telescope', 'builtin', 'fzf' },
	},
}
