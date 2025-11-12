vim.g.mapleader = " "

require("config.lazy")
require("core")

local get_jdtls_config = require("config.lsp.jdtls")

-- JDTLS
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

