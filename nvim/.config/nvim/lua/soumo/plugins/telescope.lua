return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "BurntSushi/ripgrep",
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    -- local fb_actions = require("telescope").extensions.file_browser.actions
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })

    telescope.setup({
      defaults = {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        path_display = { "smart" },
        file_ignore_patterns = { "node_modules" }, -- Optionally ignore unwanted folders
        hidden = true, -- This enables searching hidden files
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.open,
          },
        },
      },

      pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
        find_files = {
          hidden = true, -- Ensure `find_files` searches hidden files
        },
      },
      extensions = {
        file_browser = {
          theme = "dropdown",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
        },
      },
    })

    telescope.load_extension("fzf")
    -- telescope.load_extension("file_browser")

    local function telescope_buffer_dir()
      -- vim.cmd("lcd " .. vim.fn.expand("%:p:h"))
      return telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        cwd = vim.fn.expand("%:p:h"),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        previewer = false,
        initial_mode = "normal",
        layout_config = { height = 40 },
      })
    end

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    -- require("telescope.builtin").find_files({ hidden = true })

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fl", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope resume<cr>", { desc = "Resume the previous telescope picker" })
    keymap.set(
      "n",
      "<leader>fd",
      "<cmd>Telescope diagnostics<cr>",
      { desc = "Lists diagnostics for all open buffers or a specific buffer" }
    )
    keymap.set(
      "n",
      "<leader>fe",
      "<cmd>Telescope treesitter<cr>",
      { desc = "Lists function names, variables, from treesitter" }
    )
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set(
      "n",
      "<leader>fb",
      telescope_buffer_dir,
      { desc = "Open file browser with the path of the current buffer" }
    )
  end,
}
