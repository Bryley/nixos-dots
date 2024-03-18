return {
    {
        -- Onedark colorscheme
        "navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                style = "darker",
                -- style='deep',
                transparent = false,
                toggle_style_key = "<leader>ts", -- nil to disable or set it to a string, for example "<leader>ts"
                toggle_style_list = { "deep", "light" },
            })

            require("onedark").load()
            -- config()
        end,
    },
    {
        "Shatur/neovim-session-manager",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        lazy = false,
        keys = {
            { "<F1>", "<cmd>SessionManager load_current_dir_session<cr>", desc = "Load last session" },
        },
        config = function()
            require("session_manager").setup({
                autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
            })
        end,
    },

    {
        -- Smooth scrolling for neovim
        "declancm/cinnamon.nvim",
        config = true,
    },
    {
        -- Ability to change surrounding characters on text objects.
        "kylechui/nvim-surround",
        config = true,
    },
    {
        -- Better commenting using the `gc<motion>` keybinding
        "numToStr/Comment.nvim",
        config = true,
        lazy = false,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        lazy = true,
        config = true,
    },
    {
        -- TODO maybe consider not using this
        -- Adds lots of base16 colorschemes
        "RRethy/nvim-base16",
    },
    {
        -- Toggles background transparency
        "xiyaowong/transparent.nvim",
    },
    {
        -- GUI for quickly selecting from a list of things
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").setup({
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                    },
                },
            })
        end,
    },
    {
        -- Adds :BufDel command for a more intuitive buffer delete (binded to Alt-C)
        "ojroques/nvim-bufdel",
        opts = {
            -- Custom next function to go to the last visited buffer
            next = function ()
                local buf = vim.api.nvim_get_current_buf()
                local jumplist = vim.fn.getjumplist()[1]

                local size = #jumplist

                for index, _ in ipairs(jumplist) do
                    local element = jumplist[size - index + 1]
                    local next_buf = element["bufnr"]

                    if next_buf ~= buf then
                        return next_buf
                    end

                end

                return 0
            end
        },
    },
    {
        -- Better Quickfix window with previews and fuzzy file search
        'kevinhwang91/nvim-bqf'
    },
    {
        -- Change text to snake_case, camelCase, PascalCase, kebab-case and more
        'johmsalas/text-case.nvim',
        lazy = false,
        config = function ()
            require("textcase").setup({});
        end,
    }
    -- TODO Terminal and Tmux integration
}
