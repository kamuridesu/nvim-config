return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig", -- Ensure nvim-lspconfig is loaded
	},
	config = function()
		require("mason").setup()

		local mason_lspconfig = require("mason-lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Define on_attach function
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

		-- Configure mason-lspconfig
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
			},
		})

		-- Set up LSP handlers
		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end,
			-- Server-specific configurations
			["html"] = function()
				require("lspconfig").html.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end,
			-- Add other server-specific configs if needed
		})

		-- Configure mason-tool-installer
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
