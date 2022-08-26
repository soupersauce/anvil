local vim = vim
local ufo_ok, ufo = pcall(require, 'ufo')

if not ufo_ok then
	return
end

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = ('  %d '):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, 'MoreMsg' })
	return newVirtText
end

vim.api.nvim_create_autocmd({ 'FileType' }, {
	pattern = { 'org' },
	callback = function()
		ufo.detach()
	end,
})

ufo.setup {
	provider_selector = function(bufnr, filetype, buftype)
		return { 'treesitter', 'indent' }
	end,
	fold_virt_text_handler = handler,
}
