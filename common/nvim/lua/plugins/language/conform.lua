return {
    "stevearc/conform.nvim",

    event = {
        "BufReadPre",
        "BufNewFile",
    },

    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({
                    async = false,
                    lsp_format = "fallback",
                })
            end,
            mode = { "n", "v" },
            desc = "Format buffer or selection",
        },
    },

    config = function()
        local conform = require("conform")

        conform.formatters.verible = {
            append_args = {
                -- lowRISC basic formatting.
                "--indentation_spaces=2",
                "--wrap_spaces=4",
                "--column_limit=100",

                -- Align parameter and port declarations.
                "--formal_parameters_alignment=align",
                "--port_declarations_alignment=align",

                -- Align internal signal declarations.
                "--module_net_variable_alignment=align",

                -- Align module instantiations.
                "--named_parameter_alignment=align",
                "--named_port_alignment=align",

                -- Treat blank lines as separate alignment tables.
                "--alignment_group_boundary=blank-lines",
            },
        }

        conform.setup({
            formatters_by_ft = {
                systemverilog = { "verible" },
                verilog = { "verible" },
            },

            format_on_save = {
                timeout_ms = 2000,
                lsp_format = "fallback",
            },
        })
    end,
}
