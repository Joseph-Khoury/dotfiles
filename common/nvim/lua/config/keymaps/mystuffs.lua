-- Toggle autocompletion
local cmp_toggle = require("mystuffs.cmp_toggle")
vim.keymap.set("n", "<C-k>", cmp_toggle.toggle, {desc = "Toggle cmp autocompletion" })

-- -- file execution
-- local file_execution = require("mystuffs.file_execution")
-- vim.keymap.set("n", "<leader>rn", file_execution.run_code, { desc = "Execute the current file via a console command" })
