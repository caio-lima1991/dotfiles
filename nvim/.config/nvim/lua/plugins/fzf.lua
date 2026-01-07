-- lua/plugins/fzf.lua
return {
  -- 1. Plugin Specification for fzf-lua
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",

    opts = {
      defaults = {
        formatter = "path.filename_first",
      },

      files = {
        cwd_prompt = false,
      },
    },

    config = function(_, opts)
      local fzf = require("fzf-lua")

      -- Apply the default options from the opts table above
      fzf.setup(opts)
      local config = fzf.config

      -- FZF Terminal Mappings
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"

      -- Builtin UI Mappings
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"
    end,

    -- 2. Keymaps
    keys = {
      -- fzf-lua keys (t mode)
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },

      -- Original LazyVim Picker Keymaps: Replaced LazyVim.pick(...)
      { "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
      { "<leader>/", "<cmd>FzfLua live_grep formatter=path.filename_first<cr>", desc = "Grep (Root Dir)" },
      { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader><space>", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },

      -- find
      { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>fB", "<cmd>FzfLua buffers<cr>", desc = "Buffers (all)" },
      { "<leader>fc", "<cmd>FzfLua files root=false cwd=~/.config/nvim<cr>", desc = "Find Config File" },
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
      { "<leader>fF", "<cmd>FzfLua files root=false<cr>", desc = "Find Files (cwd)" },
      { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", "<cmd>FzfLua oldfiles cwd=" .. vim.uv.cwd() .. "<cr>", desc = "Recent (cwd)" },

      -- git
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
      { "<leader>gd", "<cmd>FzfLua git_diff<cr>", desc = "Git Diff (hunks)" },
      { "<leader>gl", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
      { "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },

      -- search
      { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
      { "<leader>s/", "<cmd>FzfLua search_history<cr>", desc = "Search History" },
      { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>FzfLua lines<cr>", desc = "Buffer Lines" },
      { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
      { "<leader>sD", "<cmd>FzfLua diagnostics_document<cr>", desc = "Buffer Diagnostics" },
      { "<leader>sg", "<cmd>FzfLua live_grep formatter=path.filename_first<cr>", desc = "Grep (Root Dir)" },
      { "<leader>sG", "<cmd>FzfLua live_grep_native root=false<cr>", desc = "Grep (cwd)" },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
      { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
      { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
      { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
      { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
      { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
      { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Word (Root Dir)" },
      { "<leader>sW", "<cmd>FzfLua grep_cword root=false<cr>", desc = "Word (cwd)" },
      { "<leader>sw", "<cmd>FzfLua grep_visual<cr>", mode = "x", desc = "Selection (Root Dir)" },
      { "<leader>sW", "<cmd>FzfLua grep_visual root=false<cr>", mode = "x", desc = "Selection (cwd)" },

      -- Symbols
      {
        "<leader>ss",
        function()
          require("fzf-lua").lsp_document_symbols({})
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("fzf-lua").lsp_live_workspace_symbols({})
        end,
        desc = "Goto Symbol (Workspace)",
      },
    },
  },

  -- nvim-lspconfig keymaps
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "gd",
        "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>",
        desc = "Goto Definition",
      },
      {
        "grr",
        "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>",
        desc = "References",
      },
      {
        "gri",
        "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>",
        desc = "Goto Implementation",
      },
      {
        "gy",
        "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>",
        desc = "Goto T[y]pe Definition",
      },
    },
  },
}
