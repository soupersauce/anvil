local dressing_ok, dressing = pcall(require, 'dressing')

if not dressing_ok then
	print('No Dressing')
	return
end

dressing.setup {
	select = {
		backend = { 'fzf_lua', 'fzf', 'nui', 'telescope', 'builtin' },
	},
}
