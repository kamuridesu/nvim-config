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

		local function trim(s)
			return (s:gsub("^%s*(.-)%s*$", "%1"))
		end

		local function read_hostname_file()
			local file = io.open("/etc/hostname", "r")
			local content = file:read("*all")
			file:close()
			return trim(content)
		end

		local function read_hostname_cmd()
			local cmd = io.popen("hostname")
			local hostname = cmd:read("*all")
			cmd:close()
			return trim(hostname)
		end

		local hostname = read_hostname_file() or read_hostname_cmd()

		local common_lsp = {
			"eslint",
			"tailwindcss",
			"ts_ls",
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
		}

		local handlers = {
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
			["tailwindcss"] = function()
				require("lspconfig").tailwindcss.setup({
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
		}

		local function kamint_custom_config() end

		local function dainsleif_custom_config()
			table.insert(common_lsp, "csharp_ls")
			handlers["csharp_ls"] = function()
				require("lspconfig").csharp_ls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end
		end

		local hostsmap = {
			kamint = kamint_custom_config,
			dainsleif = dainsleif_custom_config,
		}

		host_setup_func = hostsmap[hostname]
		if host_setup_func then
			host_setup_func()
		end

		mason_lspconfig.setup({
			automatic_installation = true,
			ensure_installed = common_lsp,
		})

		mason_lspconfig.setup_handlers(handlers)

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
