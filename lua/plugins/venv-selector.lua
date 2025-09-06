return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python", --optional
	},
	lazy = false,
	keys = {
		{ ",v", "<cmd>VenvSelect<cr>" },
	},
	---@type venv-selector.Config
	opts = {
		-- Your settings go here
	},
}
