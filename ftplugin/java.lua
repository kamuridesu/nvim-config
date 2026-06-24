local HOME = os.getenv("HOME")
local PROJECT_FOLDER = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml" }) or ""
local PROJECT_NAME = vim.fn.fnamemodify(PROJECT_FOLDER, ":p:t")
local WORKSPACE_DIR = HOME .. "/.local/share/eclipse/" .. PROJECT_NAME
local JDTLS_FOLDER = HOME .. "/.local/share/nvim/mason/packages/jdtls/"
local CONFIG_FOLDER = JDTLS_FOLDER .. "config_linux"
local LOMBOK_PATH = JDTLS_FOLDER .. "lombok.jar"
local sdkman_dir = HOME .. "/.sdkman/candidates/java/"
local system_jvm_dir = "/usr/lib/jvm/"

local function fetch_java_folder(version)
    local sdkman_matches = vim.fn.glob(sdkman_dir .. version .. "*", true, true)
    if #sdkman_matches > 0 then
        table.sort(sdkman_matches)
        return sdkman_matches[#sdkman_matches]
    end

    local sys_matches = vim.fn.glob(system_jvm_dir .. "*java*" .. version .. "*", true, true)
    if #sys_matches == 0 then
        sys_matches = vim.fn.glob(system_jvm_dir .. "*jdk*" .. version .. "*", true, true)
    end
    if #sys_matches > 0 then
        table.sort(sys_matches)
        return sys_matches[#sys_matches]
    end
    return nil
end

local runtimes = {}

local function add_runtime(name, version_prefix)
    local path = fetch_java_folder(version_prefix)
    if path then
        table.insert(runtimes, {
            name = name,
            path = path,
        })
    end
end

add_runtime("JavaSE-17", "17")
add_runtime("JavaSE-11", "11")
add_runtime("JavaSE-1.8", "8")
add_runtime("JavaSE-21", "21")
add_runtime("JavaSE-25", "25")

local bundles = vim.fn.glob(
    HOME .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    true,
    true
)

vim.list_extend(
    bundles,
    vim.fn.glob(HOME .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar", true, true)
)

local config = {
    cmd = {
        os.getenv("JAVA_HOME") .. "/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. LOMBOK_PATH,
        "-Xmx4g",
        "-jar",
        vim.fn.glob(JDTLS_FOLDER .. "plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1],
        "-configuration",
        CONFIG_FOLDER,
        "-data",
        WORKSPACE_DIR,
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
    },
    root_dir = PROJECT_FOLDER,

    settings = {
        java = {
            lombok = {
                enabled = true,
            },
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
                    "java.util.Collections",
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
                ["hashCodeEquals.useJava7Objects"] = true,
                useBlocks = true,
            },
            configuration = {
                runtimes = runtimes
            },
        },
    },

    init_options = {
        bundles = bundles,
    },
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.configuration = true
capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
capabilities.workspace.didChangeConfiguration = { dynamicRegistration = true }

require("jdtls").start_or_attach({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
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
