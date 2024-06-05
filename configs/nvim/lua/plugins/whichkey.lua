return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function()
            local whichkey = require("which-key")
            local opts = {
                mode = "n", -- NORMAL mode
                prefix = "<leader>",
            }
            local vopts = {
                mode = "v", -- VISUAL mode
                prefix = "<leader>",
            }
            whichkey.register({
                a = {
                    name = "AI",
                    t = { "<cmd>NeoAIShortcut textify<cr>", "Textify" },
                },
            }, vopts)
            whichkey.register({
                a = {
                    name = "AI",
                    a = { "<cmd>NeoAI<cr>", "Open NeoAI" },
                    g = { "<cmd>NeoAIShortcut gitcommit<cr>", "Git Commit Message" },
                },
                f = {
                    name = "Telescope",
                    f = { "<cmd>Telescope find_files<cr>", "Files" },
                    g = { "<cmd>Telescope live_grep<cr>", "Grep" },
                    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
                    h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
                    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
                    r = { "<cmd>Telescope registers<cr>", "Registers" },
                    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
                    C = { "<cmd>Telescope commands<cr>", "Commands" },
                    j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
                },
                l = {
                    name = "LSP",
                    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
                    f = { "<cmd>lua vim.lsp.buf.format()<cr><cmd>retab<cr>", "Format" },
                    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
                    n = { "<cmd>lua require('nvim-navbuddy').open()<cr>", "Navbuddy" },
                    d = { "<cmd>lua vim.diagnostic.setqflist()<cr>", "Diagnostics" },
                },
                t = {
                    name = "Table Mode",
                    m = { "<cmd>call tablemode#Toggle()<cr>", "Toggle" },
                    t = { "<cmd>Tableize<cr>", "Tableize" },
                },
                -- nvim-dap debugging
                d = {
                    name = "Debug",
                    d = { '<cmd>lua require("dapui").toggle()<CR>', "Open UI" },
                    ["<space>"] = { '<cmd>lua require("dap").continue()<CR>', "Continue" },
                    t = { '<cmd>lua require("dap").terminate()<CR>', "Terminate" },
                    j = { '<cmd>lua require("dap").step_over()<CR>', "Step Over" },
                    i = { '<cmd>lua require("dap").step_into()<CR>', "Step Into" },
                    o = { '<cmd>lua require("dap").step_out()<CR>', "Step Out" },
                    b = { '<cmd>lua require("dap").toggle_breakpoint()<CR>', "Toggle Breakpoint" },
                    c = {
                        '<cmd>lua require("dap").set_breakpoint(vim.ui.input("Breakpoint condition: "))<CR>',
                        "Breakpoint Condition",
                    },
                },
                q = {
                    name = "Quickfix",
                    k = { "<cmd>cprev<CR>zz", "Prev Quickfix" },
                    j = { "<cmd>cnext<CR>zz", "Next Quickfix" },
                    q = {
                        "<cmd>if empty(filter(getwininfo(), 'v:val.quickfix')) | botright copen | else | cclose | endif<CR>",
                        "Toggle window",
                    },
                },
            }, opts)
        end,
    },
}
