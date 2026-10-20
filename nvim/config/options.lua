-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.relativenumber = true

opt.grepprg = "rg --vimgrep -g '!*.js' -g '*.js'"

-- Tabs of width 4 by default; .editorconfig in a project still overrides this
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 0

-- YAML forbids tabs: 4 spaces (the runtime ftplugin would force 2 otherwise)
vim.g.yaml_recommended_style = 0
vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})
