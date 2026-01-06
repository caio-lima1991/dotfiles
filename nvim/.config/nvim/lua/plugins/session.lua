return {
  "rmagatti/auto-session",
  lazy = false,
  priority = 50,
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    session_lens = {
      picker = "select",
    },
  },
  keys = {
    { "<leader>qr", "<cmd>AutoSession search<CR>", desc = "Session search" },
    { "<leader>qs", "<cmd>AutoSession save<CR>", desc = "Save session" },
    { "<leader>qa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
  },
}
