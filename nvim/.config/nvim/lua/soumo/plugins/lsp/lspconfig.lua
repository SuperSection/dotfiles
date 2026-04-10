return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import mason_lspconfig plugin
    ---@type boolean, table
    local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not ok_mason_lspconfig then
      vim.notify("mason-lspconfig.nvim is not installed!", vim.log.levels.ERROR)
      return
    end

    -- import cmp-nvim-lsp plugin
    ---@type boolean, table
    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not ok_cmp then
      vim.notify("cmp_nvim_lsp is not installed!", vim.log.levels.ERROR)
      return
    end

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
        keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1 })
        end, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1 })
        end, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    local on_attach = function(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    end

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- setup servers manually
    local servers = mason_lspconfig.get_installed_servers()

    -- Setup mason-lspconfig with the server list and disable automatic enabling
    mason_lspconfig.setup({
      ensure_installed = servers,
      automatic_installation = false, -- do not auto-install; use Mason UI to install manually
      automatic_enable = false, -- disable auto enabling; we enable each manually
    })

    for _, lsp in ipairs(servers) do
      if lsp == "svelte" then
        -- configure svelte server
        vim.lsp.config("svelte", {
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
      elseif lsp == "ts_ls" then
        -- configure typescript server
        vim.lsp.config("ts_ls", {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
      elseif lsp == "eslint" then
        -- configure eslint language server
        vim.lsp.config("eslint", {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html" },
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
      elseif lsp == "cssls" then
        -- Setup CSS LS
        vim.lsp.config("cssls", {
          capabilities = capabilities,
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
        })
      elseif lsp == "tailwindcss" then
        -- configure Tailwind CSS language server
        vim.lsp.config("tailwindcss", {
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
      elseif lsp == "graphql" then
        -- configure graphql language server
        vim.lsp.config("graphql", {
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      elseif lsp == "emmet_ls" then
        -- configure emmet language server
        vim.lsp.config("emmet_ls", {
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      elseif lsp == "lua_ls" then
        -- configure lua server (with special settings)
        vim.lsp.config("lua_ls", {
          single_file_support = true,
          capabilities = capabilities,
          settings = {
            Lua = {
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
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
              runtime = {
                version = "LuaJIT",
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
      elseif lsp == "elixirls" then
        -- configure emmet language server
        vim.lsp.config("elixirls", {
          capabilities = capabilities,
          cmd = { "elixir-ls" }, -- Assuming mason installed the correct binary
          settings = {
            elixirLS = {
              dialyzerEnabled = false,
              fetchDeps = false,
            },
          },
        })
      elseif lsp == "gopls" then
        -- configure Go LSP for Templ
        vim.lsp.config("gopls", {
          capabilities = capabilities,
          on_attach = on_attach,
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = function(bufnr)
            return vim.fs.root(bufnr, { "go.mod", ".git" }) or vim.loop.cwd()
          end,
        })
      elseif lsp == "rust_analyzer" then
        -- configure rust-analyzer
        vim.lsp.config("rust_analyzer", {
          capabilities = capabilities,
          filetypes = { "rust" },
          root_dir = function(bufnr)
            return vim.fs.root(bufnr, { "Cargo.toml" }) or vim.loop.cwd()
          end,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
            },
          },
        })
      elseif lsp == "html" then
        -- configure HTML LSP for HTMX
        vim.lsp.config("html", {
          filetypes = { "html", "htmldjango", "templ" }, -- HTML and templates
          init_options = {
            configurationSection = { "html", "javascript", "typescript", "css" },
            embeddedLanguages = {
              css = true,
              javascript = true, -- <-- this enables JS inside <script>
            },
          },
          settings = {
            html = {
              format = {
                enable = true,
              },
            },
          },
        })
      else
        -- default handler for installed servers
        vim.lsp.config(lsp, {
          capabilities = capabilities,
          inlay_hints = { enable = true },
        })
      end
    end
  end,
}
