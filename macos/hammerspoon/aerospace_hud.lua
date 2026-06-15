local M = {}

local canvas

local function getWorkspaceWindows(index)
    local handle = io.popen("/opt/homebrew/bin/aerospace list-windows --workspace " .. index)
    if not handle then return {} end
    local result = handle:read("*a")
    handle:close()

    local windows = {}
    for line in result:gmatch("[^\r\n]+") do
        table.insert(windows, line)
    end
    return windows
end

local function buildWorkspaceMap(workspaceIDs)
    local map = {}
    for _, wid in ipairs(workspaceIDs) do
        local wins = getWorkspaceWindows(wid)
        if #wins > 0 then
            map[wid] = wins
        end
    end
    return map
end

local function display(text, width, height, margin)
    canvas = hs.canvas.new({
        x = (hs.screen.mainScreen():frame().w - width) / 2,
        y = (hs.screen.mainScreen():frame().h - height) / 2,
        w = width,
        h = height
    }):show()

    canvas[1] = {
        type = "rectangle",
        action = "fill",
        fillColor = { red = 0.1, green = 0.1, blue = 0.1, alpha = 0.9 },
        roundedRectRadii = { xRadius = 16, yRadius = 16 },
        withShadow = true
    }

    canvas[2] = {
        type = "text",
        text = text,
        textSize = 16,
        textFont = "JetBrainsMono Nerd Font", -- replace with your preferred monospace font
        textColor = { white = 1 },
        shadow = {
            offset = { h = 1, w = 1 },
            blurRadius = 4,
            color = { black = 0.6, alpha = 1 }
        },
        textAlignment = "left",
        frame = {
            x = margin,
            y = margin,
            w = width - 2 * margin,
            h = height - 2 * margin
        }
    }

    -- Optional: auto-hide after 8 seconds
    hs.timer.doAfter(12, function()
        if canvas then
            canvas:delete()
            canvas = nil
        end
    end)
end

function M.toggleHUD ()
    if canvas then canvas:delete(); canvas = nil; return end

    local workspaceIDs = {}
    for i = 1, 9 do
        table.insert(workspaceIDs, tostring(i))
    end
    for i = string.byte("A"), string.byte("Z") do
        table.insert(workspaceIDs, string.char(i))
    end

    local data = buildWorkspaceMap(workspaceIDs)

    local text = ""
    for _, i in ipairs(workspaceIDs) do
        local wins = data[i]
        if wins then
            text = text .. "Workspace " .. i .. ":\n"
            for _, raw_title in ipairs(wins) do
                local title = raw_title:match(".*|%s*(.-)%s*$") or raw_title
                text = text .. "  • " .. title .. "\n"
            end
            text = text .. "\n"
        end
    end

    local width, height = 700, 600
    local margin = 30
    display(text, width, height, margin)
end

return M

