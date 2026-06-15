local M = {}
function M.run_code()
    vim.notify("Function start")
    local ext = vim.fn.expand('%:e')
    local commands = {
        sh = 'bash %',
        zsh = 'source %',
        py = 'python %',
    }

    local cmd = commands[ext]
    if cmd then
        vim.cmd('!' .. cmd)
    else
        vim.notify("Filetype not supported!\nTo run this file, please add an execution command to " .. vim.fn.expand('%:p'), vim.log.levels.WARN)
    end
end
return M
