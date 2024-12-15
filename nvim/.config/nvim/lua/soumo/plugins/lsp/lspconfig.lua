return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Learning LSP
    local client_mylsp = vim.lsp.start_client({
      name = "learninglsp",
      cmd = { "/home/soumo/go/src/learninglsp/main" },
      on_attach = require("soumo.plugins").on_attach,
    })

    if not client_mylsp then
      vim.notify("Hey you didn't do the client thing good")
      return
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.lsp.buf_attach_client(0, client_mylsp)
      end,
    })

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
          inlay_hints = { enable = true },
        })
      end,
      ["svelte"] = function()
        -- configure svelte server
        lspconfig["svelte"].setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                -- Here use ctx.match instead of ctx.file
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end,
        })
      end,
      ["ts_ls"] = function()
        -- configure typescript server
        lspconfig["ts_ls"].setup({
          single_file_support = false,
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            -- Disable tsserver's formatting capabilities to use Prettier or ESLint instead
            client.server_capabilities.documentFormattingProvider = false
          end,
          cmd = { "npx", "typescript-language-server", "--stdio" },
          settings = {
            workingDirectory = { mode = "auto" },
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        })
      end,
      ["eslint"] = function()
        -- configure eslint language server
        lspconfig["eslint"].setup({
          settings = {
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine",
              },
              showDocumentation = {
                enable = true,
              },
            },
          },
          on_attach = function(client, bufnr)
            -- Enable document formatting (autofix on save)
            if client.server_capabilities.documentFormattingProvider then
              vim.api.nvim_command([[augroup Format]])
              vim.api.nvim_command([[autocmd! * <buffer>]])
              vim.api.nvim_command([[autocmd BufWritePre <buffer> EslintFixAll]]) -- Auto-fix on save
              vim.api.nvim_command([[augroup END]])
            end

            -- Disable ESLint for non-JavaScript/TypeScript files
            if vim.bo[bufnr].filetype ~= "javascript" and vim.bo[bufnr].filetype ~= "typescript" then
              client.stop()
            end

            -- Keymap for code actions
            vim.api.nvim_buf_set_keymap(
              bufnr,
              "n",
              "<leader>ca",
              "<cmd>lua vim.lsp.buf.code_action()<CR>",
              { desc = "ESLint code actions" }
            )
            vim.api.nvim_buf_set_keymap(
              bufnr,
              "n",
              "<leader>cf",
              "<cmd>lua vim.lsp.buf.format()<CR>",
              { desc = "Format with ESLint" }
            )
          end,
        })
      end,
      ["tailwindcss"] = function()
        -- configure emmet language server
        lspconfig["tailwindcss"].setup({
          capabilities = capabilities,
          init_options = {
            userLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
            },
          },
          on_attach = function(client, bufnr)
            -- Customize behavior or keybindings for Tailwind LSP here
          end,
          filetypes = {
            "html",
            "css",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  -- For frameworks like twin.macro or similar custom class names
                  { "tw`([^`]*)", "tw\\([^)]*\\)" },
                },
              },
            },
          },
        })
      end,
      ["graphql"] = function()
        -- configure graphql language server
        lspconfig["graphql"].setup({
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      end,
      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          single_file_support = true,
          capabilities = capabilities,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
                disable = { "incomplete-signature-doc", "trailing-space" },
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              completion = {
                callSnippet = "Replace",
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        })
      end,
      ["elixirls"] = function()
        -- configure emmet language server
        lspconfig["elixirls"].setup({
          capabilities = capabilities,
          cmd = { "elixir-ls" }, -- Assuming mason installed the correct binary
          settings = {
            elixirLS = {
              dialyzerEnabled = false,
              fetchDeps = false,
            },
          },
        })
      end,
      ["gopls"] = function()
        -- configure Go LSP for Templ
        lspconfig["gopls"].setup({
          cmd = { "gopls" },
          filetypes = { "go", "gotmpl" }, -- Templ is Go template files
          root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
        })
      end,
      ["html"] = function()
        -- configure HTML LSP for HTMX
        lspconfig["html"].setup({
          filetypes = { "html", "htmldjango", "templ" }, -- HTML and templates
          settings = {
            html = {
              format = {
                enable = true,
              },
            },
          },
        })
      end,
    })
  end,
}
