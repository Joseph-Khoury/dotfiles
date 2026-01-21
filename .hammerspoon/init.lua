-- Hello World
hs.hotkey.bind({"ctrl", "cmd", "alt"}, "H", function()
    hs.alert.show("Hello, World!")
end)

-- Fancier Hello World
hs.hotkey.bind({"ctrl", "cmd", "alt"}, "W", function()
    hs.notify.new({title="Hammerspoon", informativeText="Hello, World!"}):send()
end)

-- Example with a spoon to show a clock
hs.loadSpoon("AClock")
hs.hotkey.bind({"ctrl", "cmd", "alt"}, "C", function()
    spoon.AClock:toggleShow()
end)

-- reload hammerspoon config
hs.hotkey.bind({"ctrl", "cmd", "alt"}, "R", function()
    hs.reload()
    hs.notify.new({title="Hammerspoon", informativeText="Reloaded config"}):send()
end)

-- Open a new terminal window
hs.hotkey.bind({"ctrl", "cmd"}, "\\", function ()
    hs.execute("open -na Alacritty")
end)

-- Aerospace HUD
local aerospaceHUD = require("aerospace_hud")
hs.hotkey.bind({"alt", "cmd"}, "tab", aerospaceHUD.toggleHUD)

-- -- quick alphabet (for jetpunk quiz)
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "A", function()
--     for i = string.byte("A"), string.byte("Z") do
--         hs.eventtap.keyStrokes(string.char(i))
--         -- hs.timer.usleep(100000) -- 0.1 sec
--         hs.eventtap.keyStroke({}, "delete")
--         -- hs.timer.usleep(100000)
--     end
-- end)
