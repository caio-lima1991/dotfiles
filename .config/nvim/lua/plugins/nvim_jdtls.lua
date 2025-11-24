return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local get_jdtls_config = require("config.lsp.jdtls")

      local function jdtls_autostart()
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          if client.name == "jdtls" then
            return
          end
        end
        require("jdtls").start_or_attach(get_jdtls_config())
      end

      vim.api.nvim_create_augroup("JDTLS_LSP_START", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = "JDTLS_LSP_START",
        pattern = "java",
        callback = jdtls_autostart,
        desc = "Start nvim-jdtls for Java files",
      })
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
