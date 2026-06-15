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

-- Import spoon for floating windows control for aerospace
hs.loadSpoon("FloatingWindows")

spoon.FloatingWindows.moveStep = 40
spoon.FloatingWindows.resizeStep = 40

spoon.FloatingWindows:start()

-- Extract hotkeys for obsidian database
function ExportHammerspoonHotkeys()
  local hotkeys = hs.hotkey.getHotkeys()
  local out = {}

  for _, hk in ipairs(hotkeys) do
    table.insert(out, {
      app = "hammerspoon",
      key = hk.idx,
      action = hk.msg or "",
    })
  end

  local dotfiles = os.getenv("DOTFILES_ROOT") or os.getenv("HOME") .. "/.dotfiles"
  local path = dotfiles .. "/macos/keybinds/generated/hammerspoon.json"

  local file = io.open(path, "w")
  if not file then
    hs.alert.show("Could not write Hammerspoon hotkeys")
    return
  end

  file:write(hs.json.encode(out, true))
  file:close()

  hs.alert.show("Exported Hammerspoon hotkeys")
end

hs.hotkey.bind({ "cmd", "ctrl", "alt" }, "e", "Export Hammerspoon hotkeys", ExportHammerspoonHotkeys)
