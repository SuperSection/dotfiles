return {
  "mrcjkb/rustaceanvim",
  version = "^6", -- Recommended
  lazy = false, -- This plugin is already lazy
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    local mason_registry = require("mason-registry")
    local codelldb = mason_registry.get_package("codelldb")

    -- Ensure codelldb is installed
    if not codelldb:is_installed() then
      print("Installing codelldb...")
      codelldb:install()
    end

    local extension_path = codelldb.get_install_path() .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"

    -- Set the correct lldb library path based on the operating system
    local lldb_lib_path
    if vim.fn.has("mac") == 1 then
      lldb_lib_path = extension_path .. "lldb/lib/liblldb.dylib"
    else -- Assuming Linux
      lldb_lib_path = extension_path .. "lldb/lib/liblldb.so"
    end

    local cfg = require("rustaceanvim.config")

    vim.g.rustaceanvim = {
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, lldb_lib_path),
      },
    }
  end,
}
