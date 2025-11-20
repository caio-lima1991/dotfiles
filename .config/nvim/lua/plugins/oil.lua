return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = {
    { "-", "<cmd>Oil --float<cr>", desc = "Open parent directory" },
  },
  opts = {
    float = {
      padding = 2,
      max_width = 0.9,
      max_height = 0.9,
      border = nil,
      win_options = {
        winblend = 0,
      },
      get_win_title = nil,
      preview_split = "auto",
      override = function(conf)
        return conf
      end,
    },
  },
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  lazy = false,
}
