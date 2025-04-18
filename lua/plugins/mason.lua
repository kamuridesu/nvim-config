return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		require("mason").setup()

		local mason_lspconfig = require("mason-lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Autoformat on save
		local on_attach = function(client, bufnr)
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

		mason_lspconfig.setup({
			automatic_installation = true,
			ensure_installed = {
				"eslint",
				"html",
				"jsonls",
				"pyright",
				"gopls",
				"ast_grep",
				"bashls",
				"docker_compose_language_service",
				"groovyls",
				"helm_ls",
				"terraformls",
				"jdtls",
			},
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end,
			["html"] = function()
				require("lspconfig").html.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end,
			["jsonls"] = function()
				require("lspconfig").jsonls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["eslint"] = function()
				require("lspconfig").eslint.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["pyright"] = function()
				require("lspconfig").pyright.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["gopls"] = function()
				require("lspconfig").gopls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["ast_grep"] = function()
				require("lspconfig").ast_grep.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["bashls"] = function()
				require("lspconfig").bashls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["docker_compose_language_service"] = function()
				require("lspconfig").docker_compose_language_service.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["groovyls"] = function()
				require("lspconfig").groovyls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["helm_ls"] = function()
				require("lspconfig").helm_ls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["terraformls"] = function()
				require("lspconfig").terraformls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"isort",
				"black",
				"pylint",
				"eslint_d",
			},
		})
	end,
}
