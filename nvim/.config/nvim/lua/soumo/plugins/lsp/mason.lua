return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local ok_mason, mason = pcall(require, "mason")
    if not ok_mason then
      vim.notify("mason.nvim is not installed!", vim.log.levels.ERROR)
      return
    end

    -- import mason-lspconfig
    local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not ok_mason_lspconfig then
      vim.notify("mason-lspconfig.nvim is not installed!", vim.log.levels.ERROR)
      return
    end

    local ok_mason_tool_installer, mason_tool_installer = pcall(require, "mason-tool-installer")
    if not ok_mason_tool_installer then
      vim.notify("mason-tool-installer.nvim is not installed!", vim.log.levels.ERROR)
      return
    end

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        -- "asm_lsp,
        "ts_ls", -- typescript-language-server
        "html", -- HTML
        "cssls", -- CSS
        "tailwindcss",
        "svelte",
        "lua_ls", -- Lua (lua-language-server)
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "gopls",
        "rust_analyzer",
        "tflint",
        "eslint", -- ESLint language server
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "asmfmt", -- assembly formatter
        "prettier", -- prettier formatter
        "prettierd",
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint", -- python linter
        "goimports-reviser", -- go formatter
        "golangci-lint", -- go linter
        "eslint_d",
        "shellcheck",
        "codelldb",
        "taplo", -- toml formatter
        "yamlfix", -- yml formatter
      },
    })
  end,
}
