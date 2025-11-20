return {
  "rmagatti/auto-session",
  event = "VimEnter",
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_save = false,
  },
  keys = {
    { "<leader>qr", "<cmd>AutoSession search<CR>", desc = "Session search" },
    { "<leader>qs", "<cmd>AutoSession save<CR>", desc = "Save session" },
  },
}
