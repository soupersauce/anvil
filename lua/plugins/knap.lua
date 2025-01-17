local M = { -- KNAP
	'frabjous/knap',
  cond = vim.g.started_by_firenvim == nil,
	ft = { 'org', 'markdown', 'tex', 'html' },
}

function M.config()
	local fn = vim.fn
	local present, knap = pcall(require, 'knap')
	local knapsettings = {}

	-- PDF: view config
	if fn.executable('siyoek') == 1 then
		knapsettings['textopdfviewerlaunch'] =
			"sioyek --inverse-search 'nvim --headless-es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,0)\"' --reuse-instance %outputfile%"
		knapsettings['textopdfviewerrefresh'] = 'none'
		knapsettings['textopdfforwardjump'] =
			"sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,0)\"' --reuse-instance --forward-search-file %srcfile% --forward-search-line %line% %outputfile%"
		knapsettings['orgtopdfviewerlaunch'] =
			"sioyek --inverse-search 'nvim --headless-es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,0)\"' --reuse-instance %outputfile%"
		knapsettings['orgtopdfviewerrefresh'] = 'none'
		knapsettings['orgtopdfforwardjump'] =
			"sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,0)\"' --reuse-instance --forward-search-file %srcfile% --forward-search-line %line% %outputfile%"
	elseif fn.executable('zathura') then
		knapsettings['textopdfviewerlaunch'] =
			"zathura --synctex-editor-command 'nvim --headless-es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%{input}'\"'\"',%{line},0)\"' %outputfile%"
		knapsettings['textopdfviewerrefresh'] = 'none'
		knapsettings['textopdfforwardjump'] = 'zathura --synctex-forward=%line%:%column%:%srcfile% %outputfile%'
		knapsettings['orgtopdfviewerlaunch'] =
			"zathura --synctex-editor-command 'nvim --headless-es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%{input}'\"'\"',%{line},0)\"' %outputfile%"
		knapsettings['orgtopdfforwardjump'] = 'zathura --synctex-forward=%line%:%column%:%srcfile% %outputfile%'
		knapsettings['orgtopdfviewerrefresh'] = 'none'
	elseif fn.executable('qpdfview') then
		knapsettings['textopdfviewerlaunch'] = 'qpdfview --unique --instance neovim %outputfile%'
		knapsettings['textopdfviewerrefresh'] = 'none'
		knapsettings['textopdfforwardjump'] =
			'qpdfview --unique --instance neovim %outputfile%#src:%srcfile%:%line%:%column%'
		knapsettings['orgtopdfviewerlaunch'] = 'qpdfview --unique --instance neovim %outputfile%'
		knapsettings['orgtopdfviewerrefresh'] = 'none'
		knapsettings['orgtopdfforwardjump'] =
			'qpdfview --unique --instance neovim %outputfile%#src:%srcfile%:%line%:%column%'
	elseif fn.executable('mupdf') then
		knapsettings['mdtopdfviewerlaunch'] = 'mupdf %outputfile%'
		knapsettings['mdtopdfviewerrefresh'] = 'kill -HUP %pid%'
		knapsettings['markdowntopdfviewerlaunch'] = 'mupdf %outputfile%'
		knapsettings['markdowntopdfviewerrefresh'] = 'kill -HUP %pid%'
		knapsettings['textopdfviewerlaunch'] = 'mupdf %outputfile%'
		knapsettings['textopdfviewerrefresh'] = 'kill -HUP %pid%'
		knapsettings['textopdfforwardjump'] = 'false'
		knapsettings['orgtopdfviewerlaunch'] = 'qpdfview --unique --instance neovim %outputfile%'
		knapsettings['orgtopdfviewerrefresh'] = 'none'
		knapsettings['orgtopdfforwardjump'] =
			'qpdfview --unique --instance neovim %outputfile%#src:%srcfile%:%line%:%column%'
	else
		print("No configured pdf reader available; using defaults probably won't work")
	end

	-- HTML: view config
	if fn.executable('qutebrowser') then
		knapsettings['mdtohtmlviewerlaunch'] =
			'SRC=%srcfile%; ID="${SRC//[^A-Za-z0-9]/_-_-}"; qutebrowser --target window %outputfile% ":spawn --userscript knap-userscript.lua $ID"'
		knapsettings['mdtohtmlviewerrefresh'] =
			'SRC=%srcfile%; ID="${SRC//[^A-Za-z0-9]/_-_-}"; echo \':run-with-count \'$(</tmp/knap-$ID-qute-tabindex)\' reload -f\' > "$(</tmp/knap-$ID-qute-fifo)"'
		knapsettings['htmltohtml'] = 'none'
		knapsettings['htmltohtmlviewerlaunch'] =
			'SRC=%srcfile%; ID="${SRC//[^A-Za-z0-9]/_-_-}"; qutebrowser --target window %outputfile% ":spawn --userscript knap-userscript.lua $ID"'
		knapsettings['htmltohtmlviewerrefresh'] =
			'SRC=%srcfile%; ID="${SRC//[^A-Za-z0-9]/_-_-}"; echo \':run-with-count \'$(</tmp/knap-$ID-qute-tabindex)\' reload -f\' > "$(</tmp/knap-$ID-qute-fifo)"'
	else
		print('No configured browser available; using defaults which may not work')
	end

	-- ORG: config
	knapsettings['orgoutputext'] = 'html'
	knapsettings['orgtopdf'] = 'pandoc %srcfile% -o %outputfile%'
	knapsettings['orgtohtml'] = 'pandoc %srcfile% -o %outputfile%'
	knapsettings['orgtohtmlviewerlaunch'] =
		'SRC=%srcfile%; ID="${SRC//[^A-Za-z0-9]/_-_-}"; qutebrowser --target window %outputfile% ":spawn --userscript knap-userscript.lua $ID"'
	knapsettings['orgtohtmlviewerrefresh'] =
		'SRC=%srcfile%; ID="${SRC//[^A-Za-z0-9]/_-_-}"; echo \':run-with-count \'$(</tmp/knap-$ID-qute-tabindex)\' reload -f\' > "$(</tmp/knap-$ID-qute-fifo)"'

	-- options = load_override(options, "lukas-reineke/indent-blankline.nvim")
	vim.g.knap_settings = knapsettings
end
return M
