local jdtls = require("jdtls")

local function get_jdtls_config()
  local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = vim.fn.expand("~/.jdtls-workspace/") .. project_name

  local lombok_path = jdtls_path .. "lombok.jar"
  local m2_repo = vim.fn.expand("~/.m2/repository")

  local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok_path,
    "-Xbootclasspath/a:" .. lombok_path,
    "-jar",
    vim.fn.glob(jdtls_path .. "plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    jdtls_path .. "config_linux",
    "-data",
    workspace_dir,
  }

  local config = {
    cmd = cmd,
    root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw", "pom.xml" }),
    extendedClientCapabilities = jdtls.extendedClientCapabilities,

    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        maven = {
          settingsFile = m2_repo .. "/settings.xml",
        },
      },
    },

    on_attach = function(client, bufnr)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
      jdtls.setup_dap({ hotcodereplace = "auto" })
    end,
  }

  return config
end

return get_jdtls_config
