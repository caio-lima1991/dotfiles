-- lua/plugins/fzf.lua
return {
  -- 1. Plugin Specification for fzf-lua
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    -- The original configuration logic is moved into the 'opts' and 'config' keys.
    opts = function()
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      -- --- Helper to check for a plugin. Replace LazyVim.has("plugin")
      local function has(name)
        return vim.tbl_get(package.loaded, name) ~= nil
      end

      -- Quickfix keymaps
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

      -- Trouble integration (if you have it installed)
      if has("trouble") then
        config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
      end

      config.defaults.actions.files["ctrl-r"] = function()
        print("toggle-root-dir (LazyVim custom logic removed)")
      end
      config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]

      -- Image Previewer setup
      local img_previewer
      for _, v in ipairs({
        { cmd = "ueberzug", args = {} },
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "viu", args = { "-b" } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      -- The main fzf-lua options table
      local opts = {
        "default-title", -- This is a profile from fzf-lua
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        defaults = {
          formatter = "path.dirname_first",
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        -- Custom ui_select override (Used to customize selection windows)
        ui_select = function(fzf_opts, items)
          local base_opts = {
            prompt = " ",
            winopts = {
              title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
              title_pos = "center",
              width = 0.5,
              -- Default height calculation (for non-codeaction)
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
            },
          }

          if fzf_opts.kind == "codeaction" then
            base_opts.winopts.layout = "vertical"
            -- Recalculate height for codeaction (with preview space)
            base_opts.winopts.height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16
            -- Simplified preview check - the original used vtsls client check
            local has_vtsls = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" }))
            base_opts.winopts.preview = has_vtsls
                and {
                  layout = "vertical",
                  vertical = "down:15,border-top",
                  hidden = "hidden",
                }
              or {
                layout = "vertical",
                vertical = "down:15,border-top",
              }
          end

          return vim.tbl_deep_extend("force", fzf_opts, base_opts)
        end,
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s -- Requires a troubles.nvim like color scheme
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
          },
        },
      }

      return opts
    end,
    config = function(_, opts)
      -- Apply 'default-title' profile adjustments
      if opts[1] == "default-title" then
        local function fix(t)
          t.prompt = t.prompt ~= nil and " " or nil
          for _, v in pairs(t) do
            if type(v) == "table" then
              fix(v)
            end
          end
          return t
        end

        -- Manually load the profile and merge the options
        local default_title_profile = require("fzf-lua.profiles.default-title")
        opts = vim.tbl_deep_extend("force", fix(default_title_profile), opts)
        opts[1] = nil -- Remove the profile name after applying
      end
      require("fzf-lua").setup(opts)
    end,
    -- 2. Keymaps (Converted from LazyVim format)
    keys = {
      -- fzf-lua keys (t mode)
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },

      -- Original LazyVim Picker Keymaps: Replaced LazyVim.pick(...)
      { "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
      { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
      { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },

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
      { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
      { "<leader>sG", "<cmd>FzfLua live_grep root=false<cr>", desc = "Grep (cwd)" },
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
      { "<leader>uC", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme with Preview" },

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

  -- 3. todo-comments.nvim integration (If you use todo-comments.nvim)
  {
    "folke/todo-comments.nvim",
    optional = true,
    keys = {
      {
        "<leader>st",
        function()
          require("todo-comments.fzf").todo()
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },

  -- 4. nvim-lspconfig keymaps (Fixed for native lazy.nvim structure)
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
