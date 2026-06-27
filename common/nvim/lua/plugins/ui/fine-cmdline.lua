return {
  {
    "VonHeikemen/fine-cmdline.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = "FineCmdline",
    keys = {
      {
        "<leader>:",
        "<cmd>FineCmdline<CR>",
        desc = "Fine command line",
        mode = "n",
      },
    },
    opts = {
      cmdline = {
        enable_keymaps = true,
        smart_history = true,
        prompt = "❯ ",
      },
      popup = {
        position = {
          row = "10%",
          col = "50%",
        },
        size = {
          width = "60%",
        },
        border = {
          style = "rounded",
        },
        win_options = {
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },
      hooks = {
        after_mount = function(input)
          vim.keymap.set("i", "<Esc>", function()
            require("fine-cmdline").fn.close()
          end, { buffer = input.bufnr })

          vim.keymap.set("i", "<C-c>", function()
            require("fine-cmdline").fn.close()
          end, { buffer = input.bufnr })
        end,
      },
    },
  },
}
