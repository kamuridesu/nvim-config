return {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	config = true,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},

	config = function()
		require("nvim-ts-autotag").setup({})
	end,
}
