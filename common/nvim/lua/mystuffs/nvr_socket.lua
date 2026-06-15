local sock = os.getenv("NVIM_LISTEN_ADDRESS")
if sock then
    vim.fn.serverstart(sock)
end
