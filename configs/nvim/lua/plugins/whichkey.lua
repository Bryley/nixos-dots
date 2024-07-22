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

            local breakpoint_cmd = [[
                <cmd>lua require("dap").set_breakpoint(vim.ui.input("Breakpoint condition: "))<CR>
            ]]

            local quickfix_toggle_cmd =
                "<cmd>if empty(filter(getwininfo(), 'v:val.quickfix')) | botright copen | else | cclose | endif<CR>"

            whichkey.add({
                -- AI
                { "<leader>a", group = "AI" },
                { "<leader>aa", "<cmd>NeoAI<cr>", desc = "Open NeoAI" },
                { "<leader>ag", "<cmd>NeoAIShortcut<cr>", desc = "Git Commit Message" },
                -- Telescope (Find)
                { "<leader>f", group = "Find" },
                { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
                { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
                { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
                { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
                { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
                { "<leader>fr", "<cmd>Telescope registers<cr>", desc = "Registers" },
                { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
                { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
                { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
                -- LSP
                { "<leader>l", group = "LSP" },
                { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
                { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr><cmd>retab<cr>", desc = "Format" },
                { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
                { "<leader>ln", "<cmd>lua require('nvim-navbuddy').open()<cr>", desc = "Navbuddy" },
                { "<leader>ld", "<cmd>lua vim.diagnostic.setqflist()<cr>", desc = "Diagnostics" },
                -- Table mode
                { "<leader>t", group = "Table" },
                { "<leader>tm", "<cmd>call tablemode#Toggle()<cr>", desc = "Toggle" },
                { "<leader>tt", "<cmd>Tableize<cr>", desc = "Tableize" },
                -- Debugging
                { "<leader>d", group = "Debug" },
                { "<leader>dd", '<cmd>lua require("dapui").toggle()<CR>', desc = "Open UI" },
                { "<leader>d<space>", '<cmd>lua require("dap").continue()<CR>', desc = "Continue" },
                { "<leader>dt", '<cmd>lua require("dap").terminate()<CR>', desc = "Terminate" },
                { "<leader>dj", '<cmd>lua require("dap").step_over()<CR>', desc = "Step Over" },
                { "<leader>di", '<cmd>lua require("dap").step_into()<CR>', desc = "Step Into" },
                { "<leader>do", '<cmd>lua require("dap").step_out()<CR>', desc = "Step Out" },
                { "<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<CR>', desc = "Toggle Breakpoint" },
                {
                    "<leader>dc",
                    breakpoint_cmd,
                    desc = "Breakpoint Condition",
                },
                -- Quickfix
                { "<leader>q", group = "Quickfix" },
                { "<leader>qk", "<cmd>cprev<CR>zz", desc = "Prev Quickfix" },
                { "<leader>qj", "<cmd>cnext<CR>zz", desc = "Next Quickfix" },
                { "<leader>qq", quickfix_toggle_cmd, desc = "Toggle window" },
            })
        end,
    },
}
