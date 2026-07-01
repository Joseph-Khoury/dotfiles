if require("utils.os").is_macos then
    vim.env.PATH = table.concat({
        "/opt/homebrew/bin",
        "/opt/homebrew/sbin",
        "/usr/local/bin",
        "/usr/local/sbin",
        vim.env.PATH or "",
    }, ":")
end
