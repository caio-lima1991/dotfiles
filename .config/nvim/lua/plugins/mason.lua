return {
  {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {},
    },
    config = function() end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls@5.1.1",
        "html@4.10.0",
        "cssls@4.10.0",
        "lua_ls@3.15.0",
        "pyright@1.1.407",
        "eslint@4.10.0",
        "jdtls@v1.52.0",
        "angularls@20.3.0",
        "marksman@2024-12-18",
      },
      automatic_enable = {
        exclude = {
          "jdtls",
        },
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        cmd = "Mason",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "prettier@3.6.2", -- prettier formatter
        "stylua@v2.3.1", -- lua formatter
        "isort@7.0.0", -- python formatter
        "google-java-format@v1.32.0",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
