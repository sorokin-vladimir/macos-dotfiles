-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Switch to normal mode
map("i", "jj", "<esc>", { silent = true })
map("i", "kk", "<esc>", { silent = true })

-- Replace current word with clip board
map("n", "<leader>v", '"_diwP', { silent = true, desc = "Replace with buffer" })

-- Split line at the cursor
map("n", "<leader>i", "<Esc>i<CR><Esc>", { desc = "Split line" })

map("n", "<leader>dl", "oconsole.log('>>> ')<Esc>2h", { noremap = true, silent = true, desc = "console log" })
map(
	"n",
	"<leader>dcl",
	"oconsole.log('>>> ')<Esc>hPla, <Esc>p",
	{ noremap = true, silent = true, desc = "Log current buff" }
)
map(
	"n",
	"<leader>dwl",
	"<Esc>yiwoconsole.log('>>> ')<Esc>hPla, <Esc>p",
	{ noremap = true, silent = true, desc = "Log current word" }
)
map(
	"n",
	"<leader>dwcl",
	"<Esc>yiwoconsole.log('>>> ')<Esc>hPla, JSON.parse(JSON.stringify(<Esc>pa ?? ''))<Esc>",
	{ noremap = true, silent = true, desc = "Log current word with deep clone" }
)

-- Get path to current file
map(
	"n",
	"<leader>cP",
	"<Esc>:echo expand('%:p')<Enter>",
	{ noremap = true, silent = true, desc = "Path to current file from root" }
)
map(
	"n",
	"<leader>cp",
	"<Esc>:echo expand('%:.')<Enter>",
	{ noremap = true, silent = true, desc = "Path to current file from cwd" }
)
