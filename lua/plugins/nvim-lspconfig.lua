return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local nvim_lsp = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")

		local protocol = require("vim.lsp.protocol")

		local on_attach = function(client, bufnr)
			-- format on save
			if client.server_capabilities.documentFormattingProvider then
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("Format", { clear = true }),
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format()
					end,
				})
			end
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		mason_lspconfig.setup_handlers({
			function(server)
				nvim_lsp[server].setup({
					capabilities = capabilities,
				})
			end,
			["html"] = function()
				nvim_lsp["html"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["jsonls"] = function()
				nvim_lsp["jsonls"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["eslint"] = function()
				nvim_lsp["eslint"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["pyright"] = function()
				nvim_lsp["pyright"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["gopls"] = function()
				nvim_lsp["gopls"].setup({
					on_attach,
					capabilities = capabilities,
				})
			end,
			["ast_grep"] = function()
				nvim_lsp["ast_grep"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["bashls"] = function()
				nvim_lsp["bashls"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["docker_compose_language_service"] = function()
				nvim_lsp["docker_compose_language_service"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["groovyls"] = function()
				nvim_lsp["groovyls"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["helm_ls"] = function()
				nvim_lsp["helm_ls"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["terraformls"] = function()
				nvim_lsp["terraformls"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
		})
	end,
}
