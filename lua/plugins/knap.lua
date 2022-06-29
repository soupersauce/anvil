local present, knap = pcall(require, "knap")

if not present then
  return
end


local knapsettings = {
  htmltohtmlviewerlaunch = "qutebrowser  \'%outputfile%\'",
  markdowntohtmlviewerlaunch = "qutebrowser \'%outputfile%\'",
  mdoutputext = "html",
}



-- options = load_override(options, "lukas-reineke/indent-blankline.nvim")
vim.g.knap_settings = knapsettings
