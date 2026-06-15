local M = {
	enabled = true,
}

function M.toggle()
	M.enabled = not M.enabled
	vim.notify("Autocompletion " .. (M.enabled and "enabled" or "disabled" ))
end

return M
