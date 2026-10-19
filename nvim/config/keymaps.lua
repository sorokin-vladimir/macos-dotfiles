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

-- Prevent using arrows
local function flash_red_and_beep()
	vim.cmd.highlight("FlashRed guifg=#ffffff guibg=#ff4444 blend=40")

	local ns = vim.api.nvim_create_namespace("flash_red")
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

	local first = vim.fn.line("w0") - 1
	local last = vim.fn.line("w$") - 1

	for line = first, last do
		vim.api.nvim_buf_add_highlight(0, ns, "FlashRed", line, 0, -1)
	end

	vim.defer_fn(function()
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
	end, 400)
end

local modes = { "n", "i", "v", "x", "o" }

for _, mode in ipairs(modes) do
	map(mode, "<Up>", function()
		flash_red_and_beep()
		-- return "<Up>"
	end, { expr = false, silent = true, desc = "Arrow Up + red flash" })

	map(mode, "<Down>", function()
		flash_red_and_beep()
		-- return "<Down>"
	end, { expr = false, silent = true, desc = "Arrow Down + red flash" })

	map(mode, "<Left>", function()
		flash_red_and_beep()
		-- return "<Left>"
	end, { expr = false, silent = true, desc = "Arrow Left + red flash" })

	map(mode, "<Right>", function()
		flash_red_and_beep()
		-- return "<Right>"
	end, { expr = false, silent = true, desc = "Arrow Right + red flash" })
end
