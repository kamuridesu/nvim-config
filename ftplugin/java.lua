LOMBOK_PATH = "~/.local/share/nvim/mason/packages/jdtls/lombok.jar"

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. LOMBOK_PATH,
		"-Xmx4g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- Path to JDTLS plugin
		"-jar",
		vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),

		-- Configuration directory
		"-configuration",
		vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/config_linux"),
		"-data",
		vim.fn.expand("~/.workspace/"),
	},

	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
			},
			configuration = {
				runtimes = {
					-- Configure your Java runtime versions here
					{
						name = "JavaSE-17",
						path = "~/.sdkman/candidates/java/17.0.14-tem/",
					},
					{
						name = "JavaSE-11",
						path = "~/.sdkman/candidates/java/11.0.23-tem/",
					},
					{
						name = "JavaSE-8",
						path = "~/.sdkman/candidates/java/8.0.442-tem/",
					},
					{
						name = "JavaSE-21",
						path = "~/.sdkman/candidates/java/21.0.5-tem/",
					},
				},
			},
		},
	},

	-- Language server initialization options
	init_options = {
		bundles = {
			-- Add any extra bundles here (e.g., lombok.jar)
		},
	},
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("jdtls").start_or_attach({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		local mason_on_attach = require("mason-lspconfig").on_attach
		if mason_on_attach then
			mason_on_attach(client, bufnr)
		end

		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end
		map("n", "<leader>jo", '<Cmd>lua require("jdtls").organize_imports()<CR>', "Organize Imports")
		map("n", "<leader>jv", '<Cmd>lua require("jdtls").extract_variable()<CR>', "Extract Variable")
		map("n", "<leader>jc", '<Cmd>lua require("jdtls").test_class()<CR>', "Test Class")
		map("n", "<leader>jm", '<Cmd>lua require("jdtls").test_nearest_method()<CR>', "Test Method")
	end,
	cmd = config.cmd,
	root_dir = config.root_dir,
	settings = config.settings,
	init_options = config.init_options,
})
