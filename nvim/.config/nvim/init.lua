vim.g.mapleader = " "
vim.opt.clipboard:append("unnamedplus")

-- VSCode config
if vim.g.vscode then
  vim.g.clipboard = "win32yank"
  vim.keymap.set(
    "n",
    "gri",
    "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>",
    { desc = "Go to Implementation" }
  )
  vim.keymap.set(
    "n",
    "grd",
    "<Cmd>call VSCodeNotify('editor.action.goToDefinition')<CR>",
    { desc = "Go to Definition" }
  )
else
  -- Neovim only
  require("config.lazy")
  require("core")
end
