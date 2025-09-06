return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.black,
				-- null_ls.builtins.formatting.flake8,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.code_actions.refactoring,
				null_ls.builtins.code_actions.gitsigns,
			},
		})
	end,
}
