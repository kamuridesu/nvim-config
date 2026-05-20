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

local hostsmap = {
    artixbox = dainsleif_custom_config,
}

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
        "b0o/SchemaStore.nvim",
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
            local server_opts = {
                on_attach = on_attach,
                capabilities = capabilities,
            }
            if name == "yamlls" then
                server_opts.settings = {
                    yaml = {
                        schemaStore = {
                            enable = false,
                            url = "",
                        },
                        schemas = require('schemastore').yaml.schemas({
                            extra = {
                                {
                                    name = "Backstage template",
                                    description = "Backstage Template v1beta3",
                                    fileMatch = { "template.yaml", "template.yml" },
                                    url = "https://json.schemastore.org/catalog-info.json"
                                }
                            }
                        }),
                    }
                }
            end

            vim.lsp.config[name] = server_opts 
        end

        require("mason").setup()
        require("mason-lspconfig").setup()
    end,
}
