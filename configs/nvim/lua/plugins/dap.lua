return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            -- Better Icons
            vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "Title", linehl = "", numhl = "" })
            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = " ", texthl = "DiagnosticFloatingInfo", linehl = "", numhl = "" }
            )
            vim.fn.sign_define("DapStopped", { text = "󰁙 ", texthl = "", linehl = "TermCursor", numhl = "" })

            local dap = require("dap")
            dap.configurations.rust = {
                {
                    type = "codelldb",
                    request = "launch",
                    name = "Launch file",
                    -- program = "${file}",
                    -- pythonPath = function()
                    --     return "/usr/bin/python"
                    -- end,
                },
            }
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb" },
            })
        end,
    },
    {
        -- Debugger user interface
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require("dapui").setup()
        end,
    },
}
