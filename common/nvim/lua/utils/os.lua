local M = {}

local uname = vim.uv.os_uname()
local sysname = uname.sysname or ""

local function read_first_line(path)
    local ok, lines = pcall(vim.fn.readfile, path, "", 1)
    if not ok or not lines or not lines[1] then
        return ""
    end
    return lines[1]
end

local proc_version = read_first_line("/proc/version"):lower()

M.is_macos = sysname == "Darwin"
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
M.is_wsl = not M.is_windows
    and (vim.env.WSL_DISTRO_NAME ~= nil or proc_version:find("microsoft") ~= nil or proc_version:find("wsl") ~= nil)
M.is_linux = sysname == "Linux" and not M.is_wsl
M.is_unix = M.is_macos or M.is_linux or M.is_wsl

function M.name()
    if M.is_wsl then
        return "wsl"
    elseif M.is_macos then
        return "macos"
    elseif M.is_linux then
        return "linux"
    elseif M.is_windows then
        return "windows"
    end
    return sysname:lower()
end

function M.executable(cmd)
    return vim.fn.executable(cmd) == 1
end

function M.has_command(cmd)
    return M.executable(cmd)
end

function M.path_exists(path)
    return vim.uv.fs_stat(vim.fn.expand(path)) ~= nil
end

function M.join(...)
    local parts = { ... }
    return table.concat(parts, "/"):gsub("/+", "/")
end

function M.stdpath(kind, ...)
    local base = vim.fn.stdpath(kind)
    if select("#", ...) == 0 then
        return base
    end
    return M.join(base, ...)
end

function M.ensure_dir(path)
    vim.fn.mkdir(vim.fn.expand(path), "p")
    return path
end

function M.nvim_socket_path()
    -- Stable enough for PDF inverse search, but not a single global /tmp/nvimsocket.
    -- Different working directories get different sockets, reducing collisions.
    local run_dir = M.ensure_dir(M.stdpath("run"))
    local cwd_hash = vim.fn.sha256(vim.fn.getcwd()):sub(1, 12)
    return M.join(run_dir, "nvim-" .. cwd_hash .. ".sock")
end

function M.start_project_server()
    if vim.v.servername ~= nil and vim.v.servername ~= "" then
        return vim.v.servername
    end

    local socket = vim.env.NVIM_LISTEN_ADDRESS or M.nvim_socket_path()
    local ok = pcall(vim.fn.serverstart, socket)
    if ok then
        return socket
    end

    return vim.v.servername
end

return M
