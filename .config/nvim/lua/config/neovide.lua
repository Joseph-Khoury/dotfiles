local M = {}

function M.setup()
    if not vim.g.neovide then
        return
    end

    vim.cmd [[
    autocmd VimEnter * if argc() == 1 | cd %:p:h | endif
    ]]

    -- Font
    vim.opt.guifont = { "JetBrainsMono Nerd Font", ":h16" }

    -- Transparency
    vim.g.neovide_opacity=0.3
    vim.g.neovide_normal_opacity = 0.3
    vim.g.neovide_window_blurred = true
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0

    -- Padding
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0

    -- macOS Command key as <D->
    -- vim.g.neovide_input_use_logo = true

    -- cursor stuff
    vim.g.neovide_cursor_animation_length = 0.08
    vim.g.neovide_cursor_trail_size = 0.0
end

return M
