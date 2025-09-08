vim.opt.tabstop = 2
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

local nvim_lsp = require("lspconfig")
vim.lsp.enable("dartls")
nvim_lsp.dartls.setup({
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	init_options = {
		onlyAnalyzeProjectsWithOpenFiles = true,
		suggestFromUnimportedLibraries = true,
		closingLabels = true,
		outline = true,
		flutterOutline = true,
	},
	root_dir = nvim_lsp.util.root_pattern("pubspec.yaml"),
	settings = {
		dart = {
			completefunctioncalls = true,
			showtodos = true,
		},
	},
	on_attach = function(client, bufnr) end,
})
