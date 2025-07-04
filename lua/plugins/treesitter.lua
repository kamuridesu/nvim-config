return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			auto_install = true,
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"javascript",
				"typescript",
				"go",
				"python",
				"groovy",
				"java",
				"rust",
				"css",
				"html",
				"markdown",
				"markdown_inline",
				"bash",
				"dockerfile",
				"gitignore",
				"tsx",
				"dart",
				"fish",
			},
			sync_install = false,
			highlight = { enable = true, additional_vim_regex_highlight = false },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			rainbow = {
				enable = true,
				disable = { "html" },
				extended_mode = false,
				max_file_lines = nil,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})

		local parsers_config = require("nvim-treesitter.parsers").get_parser_configs()
		parsers_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
	end,
}
