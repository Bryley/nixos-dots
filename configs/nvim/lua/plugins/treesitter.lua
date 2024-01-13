return {
    {
        -- Parser for many languages that provides better highlighting
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            ---@diagnostic disable: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = "all",
                ignore_install = { "smali" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true,
                },
            })
        end
    },
}
