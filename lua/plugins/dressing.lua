local dressing_ok, dressing = pcall(require, 'dressing')
-- local code_action_menu = require('code_action_menu')

if not dressing_ok then
	print('No Dressing')
	return
end

dressing.setup {
	-- select = {
	-- 	gets_config = function(opts)
	-- 		if opts.kind == 'codeaction' then
	-- 			return {
	-- 				backend = 'fzf_lua',
	-- 				fzf_lua = {},
	-- 			}
	-- 		end
	-- 	end,
	-- },
}
