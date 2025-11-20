return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local get_jdtls_config = require("config.lsp.jdtls")
      require("jdtls").start_or_attach(get_jdtls_config())
    end,
  },

  {
    "mfussenegger/nvim-dap",
    ft = "java",

    dependencies = {
      { "mason-org/mason.nvim" },
    },

    opts = function()
      local dap = require("dap")

      -- Setup Mason-DAP
      require("mason-nvim-dap").setup({ ensure_installed = { "javadbg" } })

      -- Set DAP Configurations for Java
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }
    end,
  },
}
