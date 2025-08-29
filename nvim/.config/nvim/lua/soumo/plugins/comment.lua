return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- enable comment
    comment.setup({
      -- General configuration
      padding = true, -- Add padding around comments
      sticky = true, -- Keep comments sticky while navigating

      -- Ignore lines matching a specific pattern
      ignore = "^$", -- Ignore empty lines

      -- Mapping configuration
      mappings = {
        basic = true,
        extra = true,
      },

      -- Toggler configuration
      toggler = {
        line = "gcc", -- Toggle line comment
        block = "gbc", -- Toggle block comment
      },

      -- LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        line = "gc", -- Line comment
        block = "gb", -- Block comment
      },

      -- Extra configuration
      extra = {
        above = "gcO", -- Add comment above
        below = "gco", -- Add comment below
        eol = "gcA", -- Add comment at end of line,
      },

      -- for commenting tsx, jsx, svelte, html files
      pre_hook = ts_context_commentstring.create_pre_hook(),

      -- Post-hook configuration (example: formatting comments with prettier)
      -- post_hook = function(opts)
      --   -- Assuming you have a formatter setup like nvim-prettier
      --   if vim.fn.executable("prettier") == 1 then
      --     vim.cmd("Prettier")
      --   end
      -- end,
    })
  end,
}
