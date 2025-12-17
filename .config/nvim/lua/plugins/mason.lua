return {
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls@5.1.3",
        "html@4.10.0",
        "cssls@4.10.0",
        "lua_ls@3.15.0",
        "pyright@1.1.407",
        "eslint@4.10.0",
        "jdtls@v1.54.0",
        "angularls@21.5.0",
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
        { "prettier", version = "3.7.4" },
        { "stylua", version = "v2.3.1" },
        { "isort", version = "7.0.0" },
        { "google-java-format", version = "v1.33.0" },
        { "xmlformatter", version = "0.2.8" },
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
