return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
        -- oxfmt where the project has .oxfmtrc.json, prettier everywhere else
        opts.formatters_by_ft[ft] = { "oxfmt", "prettier", stop_after_first = true }
      end
      opts.formatters = opts.formatters or {}
      opts.formatters.oxfmt = { require_cwd = true }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    -- mason = false: use the project's node_modules/.bin/oxlint, no global install
    opts = { servers = { oxlint = { mason = false } } },
  },
}
