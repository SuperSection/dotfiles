return {
  "mrcjkb/rustaceanvim",
  version = "^6", -- Recommended
  lazy = false, -- This plugin is already lazy
  ft = "rust",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    local mason_registry = require("mason-registry")
    local codelldb = mason_registry.get_package("codelldb")

    local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"

    -- Set the correct lldb library path based on the operating system
    local lldb_lib_path
    if vim.fn.has("mac") == 1 then
      lldb_lib_path = extension_path .. "lldb/lib/liblldb.dylib"
    else -- Assuming Linux or Windows
      lldb_lib_path = extension_path .. "lldb/lib/liblldb.so"
    end

    local cfg = require("rustaceanvim.config")

    vim.g.rustaceanvim = {
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, lldb_lib_path),
      },
      tools = { -- Optional settings for rust-analyzer
        server = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
            },
          },
        },
      },
    }
  end,
}
