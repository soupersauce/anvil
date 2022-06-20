local present, knap = pcall(require, "knap")

if not present then
  return
end


local knapsettings = {
  htmltohtmlviewerlaunch = "luakit -u \'%outputfile%\'",
  markdowntohtmlviewerlaunch = "luakit \'%outputfile%\'",
  mdoutputext = "pdf",
}



-- options = load_override(options, "lukas-reineke/indent-blankline.nvim")
vim.g.knap_settings = knapsettings

