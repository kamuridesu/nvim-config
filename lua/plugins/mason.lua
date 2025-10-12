-- Trim string to remove trailing whitespace
local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Reads hostname file
local function read_hostname_file()
	local file = io.open("/etc/hostname", "r")
	local content = file:read("*all")
	file:close()
	return trim(content)
end

-- Reads hostname from `hostname` command
local function read_hostname_cmd()
	local cmd = io.popen("hostname")
	local hostname = cmd:read("*all")
	cmd:close()
	return trim(hostname)
end

-- Tries to read hostname from file using the command as fallback
local hostname = read_hostname_file() or read_hostname_cmd()

-- Common LSP on all my hosts
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
	"lua_ls",
	"cmake",
	"yamlls",
	"dockerls",
	"css_variables",
	"cssls",
}

-- Dainsleif custom LSPs
local function dainsleif_custom_config()
	table.insert(common_lsp, "csharp_ls")
end

-- Maps the functions to their respective hosts
local hostsmap = {
	dainsleif = dainsleif_custom_config,
}

-- Calls the function to setup the LSPs for the current host
host_setup_func = hostsmap[hostname]
if host_setup_func then
	host_setup_func()
end

-- Setup Mason LSP
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	opts = {
		ensure_installed = common_lsp,
        servers = {
          dartls = {
            cmd = {
              "dart",
              "language-server",
              "--protocol=lsp",
            },
            init_options = {
                onlyAnalyzeProjectsWithOpenFiles = true,
        		suggestFromUnimportedLibraries = true,
	    	    closingLabels = true,
		        outline = true,
        		flutterOutline = true,
            },
          },
        },
	},

	config = function(_, opts)
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

		for _, name in pairs(common_lsp) do
			vim.lsp.config[name] = {
				on_attach = on_attach,
				capabilities = capabilities,
			}
		end

		require("mason").setup()
		require("mason-lspconfig").setup()
	end,
}
