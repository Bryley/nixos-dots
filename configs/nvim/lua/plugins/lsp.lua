--- This function will be called for each LSP server to setup for lsp-config
local function server_setup(lspconfig, capabilities, server_name)
    -- Check the language and change settings for each
    local settings = nil
    local filetypes = lspconfig[server_name].document_config.default_config.filetypes
    local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, bufnr)
        end
    end
    if server_name == "lua_ls" then
        settings = {
            Lua = {
                diagnostics = {
                    globals = {
                        "vim",
                        "describe",
                        "it",
                        "before_each",
                        "after_each",
                        "before",
                        "after",
                        "assert",
                        "spy",
                        "mock",
                        "stub",
                        "pending",
                        "teardown",
                        "setup",
                        "lazy_setup",
                        "lazy_teardown",
                    },
                },
            },
        }
    elseif server_name == "pyright" then
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                },
            },
        }
    elseif server_name == "rust_analyzer" then
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    features = "all",
                },
                check = {
                    command = "clippy",
                },
                files = {
                    excludeDirs = {
                        "_build",
                        ".dart_tool",
                        ".flatpak-builder",
                        ".git",
                        ".gitlab",
                        ".gitlab-ci",
                        ".gradle",
                        ".idea",
                        ".next",
                        ".project",
                        ".scannerwork",
                        ".settings",
                        ".venv",
                        "archetype-resources",
                        "bin",
                        "hooks",
                        "node_modules",
                        "frontend/node_modules",
                        "po",
                        "screenshots",
                        "target",
                    },
                    watcherExclude = {
                        ["**/_build"] = true,
                        ["**/.classpath"] = true,
                        ["**/.dart_tool"] = true,
                        ["**/.factorypath"] = true,
                        ["**/.flatpak-builder"] = true,
                        ["**/.git/objects/**"] = true,
                        ["**/.git/subtree-cache/**"] = true,
                        ["**/.idea"] = true,
                        ["**/.project"] = true,
                        ["**/.scannerwork"] = true,
                        ["**/.settings"] = true,
                        ["**/.venv"] = true,
                        ["**/node_modules"] = true,
                    },
                },
            },
        }
        -- The rustaceanvim plugin handles setting up RA. So don't use lsp-config
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                on_attach = on_attach,
                default_settings = settings,
            },
            -- DAP configuration
            dap = {},
        }
        return
    elseif server_name == "htmx" then
        filetypes = { "html", "htmldjango" }
    elseif server_name == "jsonls" then
        settings = {
            json = {
                schemas = require("schemastore").json.schemas({
                    extra = {
                        -- TODO only works on workmac and should be removed later
                        {
                            description = "Mapping Service Test File",
                            fileMatch = "mapping-service-v2/tests/*.json",
                            name = "mapping-service-v2-test.json",
                            url = "file:///Users/bryley/Documents/repos/trading-dev/mapping-service/mapping-service-v2/mapping-service-test-schema.json",
                        },
                    },
                }),
                validate = { enable = true },
            },
        }
    end

    lspconfig[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = settings,
        filetypes = filetypes,
    })
end

--- Need this function to change documentation popup for crates
local function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand("<cword>"))
    elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
        require("crates").show_popup()
    else
        vim.lsp.buf.hover()
    end
end

return {
    {
        "neovim/nvim-lspconfig",
        keys = {
            { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "goto definition" },
            { "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "goto declaration" },
            { "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "goto references" },
            { "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "goto implementations" },
            { "K", show_documentation, desc = "show docs" },
            { "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Show signature" },
            { "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "goto prev diagnostic" },
            { "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "goto next diagnostic" },
        },
        dependencies = {
            "hrsh7th/nvim-cmp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            -- Includes JSON & YAML schemas
            "b0o/schemastore.nvim",
        },
        config = function()
            --------------------------------
            -- Setup diagnostics settings --
            --------------------------------
            vim.diagnostic.config({
                virtual_text = false,
                update_in_insert = true,
                float = {
                    border = "rounded",
                },
            })
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded",
            })

            local signs = {
                Error = "",
                Warn = "",
                Hint = "",
                Info = "",
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
            ----------------------------
            -- Setup language servers --
            ----------------------------
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    server_setup(lspconfig, capabilities, server_name)
                end,
            })
            -- Manually setup nushell LSP as it doesn't come through Mason
            lspconfig.nushell.setup({
                capabilities = capabilities,
            })
        end,
    },
    {
        -- Better LSP docs support for Neovim Lua code
        "folke/neodev.nvim",
        opts = {},
    },
    {
        -- Completion Engine for the LSP
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- Enables LSP auto completion
            "hrsh7th/cmp-buffer", -- Enables buffer completions
            "FelipeLema/cmp-async-path", -- Enables path completions
            "hrsh7th/cmp-cmdline", -- Enables cmdline completions
            "hrsh7th/cmp-nvim-lua", -- Enables nvim lua autocompletions
            "folke/neodev.nvim",
            "onsails/lspkind.nvim", -- Adds pictograms to dropdown
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")

            -- TODO NTS: Trying to work on this, need to encorp it into lsp-config capabilities or something

            ---@diagnostic disable: missing-fields
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = {
                    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-n>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end,
                    ["<C-p>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lua" },
                    { name = "nvim_lsp" },
                    { name = "async_path" },
                    { name = "luasnip" },
                    { name = "buffer", keyword_length = 3 },
                    { name = "crates" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
                experimental = {
                    ghost_text = true,
                },
            })
        end,
    },
    {
        -- Adds ability to use formatters and linters with LSP
        "nvimtools/none-ls.nvim",
        -- Config is done in the config of mason-null-ls
    },
    {
        -- Installer GUI for installing LSP servers, linters and formatters
        "williamboman/mason.nvim",
        config = true,
    },
    {
        -- Bridges gap between mason and lsp-config
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "jsonls" },
            })
        end,
    },
    {
        -- Bridges the gap between null-ls (now called none-ls) and mason
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = { "stylua", "prettier" },
                automatic_installation = false,
                handlers = {},
            })
            require("null-ls").setup({
                sources = {
                    -- Put anything here not supported by mason
                    require("null-ls").builtins.formatting.prettier.with({
                        extra_args = { "--tab-width", "4", "--use-tabs", "false" },
                        -- Additional configurations here
                    }),
                },
            })
        end,
    },
    {
        -- Adds snippets to NeoVim
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        config = function()
            require("luasnip.loaders.from_snipmate").load()
        end,
    },
    {
        -- Rust LSP plugin for managing crate dependencies and features
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup({
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            })
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
    },
    {
        -- Plugin for nushell lsp features
        "LhKipp/nvim-nu",
        build = ":TSInstall nu",
        config = function()
            require("nu").setup({})
        end,
    },
    {
        -- Adds LSP progress in bottom right corner as virtual text
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        -- Breadcrumbs at top
        "SmiteshP/nvim-navic",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        lazy = false,
        opts = {
            highlight = true,
            click = true,
        },
    },
    {
        -- Breadcrumbs GUI menu
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            lsp = { auto_attach = true },
        },
    },
}

-- return {
--     {
--         -- Handy plugin to setup LSP for us
--         "VonHeikemen/lsp-zero.nvim",
--         branch = "v3.x",
--         dependencies = {
--             -- LSP server installer
--             "williamboman/mason.nvim",
--             "williamboman/mason-lspconfig.nvim",
--             -- LSP related config options
--             "neovim/nvim-lspconfig",
--             -- Autocomplete engine
--             "hrsh7th/nvim-cmp",
--             "hrsh7th/cmp-nvim-lsp",
--             -- Snippet plugin
--             "L3MON4D3/LuaSnip",
--             -- Linting support
--             "mfussenegger/nvim-lint",
--             -- Formatting support
--             "mhartington/formatter.nvim",
--         },
--         config = function()
--             local lsp_zero = require("lsp-zero")
--             lsp_zero.on_attach(function(client, bufnr)
--                 -- see :help lsp-zero-keybindings
--                 -- to learn the available actions
--                 lsp_zero.default_keymaps({ buffer = bufnr })
--             end)
--
--             require("mason-lspconfig").setup({
--                 -- Replace the language servers listed here
--                 -- with the ones you want to install
--                 ensure_installed = { "lua_ls", "rust_analyzer" },
--                 handlers = {
--                     lsp_zero.default_setup,
--                     rust_analyzer = function()
--                         require("lspconfig").rust_analyzer.setup({
--                             settings = {
--                                 ["rust-analyzer"] = {
--                                     cargo = {
--                                         allFeatures = true,
--                                     },
--                                     check = {
--                                         command = "clippy",
--                                     },
--                                 },
--                             },
--                         })
--                     end,
--                 },
--             })
--         end,
--     },
--     {
--         "williamboman/mason.nvim",
--         config = true,
--     },
--     { "folke/neodev.nvim", opts = {} },
--     {
--         -- Breadcrumbs at top
--         "SmiteshP/nvim-navic",
--         dependencies = {
--             "neovim/nvim-lspconfig",
--         },
--         event = "User FileOpened",
--         lazy = false,
--         config = function()
--             require("nvim-navic").setup({
--                 highlight = true,
--                 click = true,
--             })
--         end,
--     },
--     {
--         -- Breadcrumbs GUI
--         "SmiteshP/nvim-navbuddy",
--         lazy = false,
--         dependencies = {
--             "neovim/nvim-lspconfig",
--             "SmiteshP/nvim-navic",
--             "MunifTanjim/nui.nvim",
--             "nvim-lualine/lualine.nvim",
--         },
--         opts = {
--             lsp = { auto_attach = true },
--         },
--     },
--     {
--         -- Adds LSP progress in bottom right corner as virtual text
--         "j-hui/fidget.nvim",
--         opts = {
--             -- options
--         },
--     },
-- }
