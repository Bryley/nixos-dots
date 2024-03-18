require("options")
require("binds")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            "abeldekat/lazyflex.nvim",
            version = "*",
            cond = true,
            import = "lazyflex.hook",
            opts = {
                enable_match = false,
                -- Put plugins (or a substring of plugin) to disable them
                kw = {
                    -- "cmp-async-path",
                    -- "cmp-buffer",
                    -- "cmp-cmdline",
                    --
                    -- "cmp-nvim-lsp",
                    -- "cmp-nvim-lua",
                    -- "nvim-cmp",
                },
            },
        },
        { import = "plugins" },
    },
})
