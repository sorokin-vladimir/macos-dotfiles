return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
	},
	opts = function(_, opts)
		local cmp = require("cmp")
		opts.mapping = cmp.mapping.preset.insert({
			["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-n>"] = nil,
			["<C-p>"] = nil,
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		})
	end,
}
