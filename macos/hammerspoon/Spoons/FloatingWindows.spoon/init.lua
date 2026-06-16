local obj = {}
obj.__index = obj

obj.name = "FloatingWindows"
obj.version = "0.1.0"
obj.author = "Joseph Khoury"

obj.moveStep = 40
obj.resizeStep = 40
obj.minWidth = 300
obj.minHeight = 180

obj.hotkeys = {}

local function focusedWindow()
    local win = hs.window.focusedWindow()

    if not win then
        hs.alert.show("No focused window")
        return nil
    end

    return win
end

local function bindAndStore(self, mods, key, fn)
    local hotkey = hs.hotkey.bind(mods, key, fn)
    table.insert(self.hotkeys, hotkey)
end

function obj:move(dx, dy)
    local win = focusedWindow()
    if not win then return end

    local f = win:frame()

    f.x = f.x + dx
    f.y = f.y + dy

    win:setFrame(f, 0)
end

function obj:resize(dw, dh)
    local win = focusedWindow()
    if not win then return end

    local f = win:frame()

    f.w = math.max(self.minWidth, f.w + dw)
    f.h = math.max(self.minHeight, f.h + dh)

    win:setFrame(f, 0)
end

function obj:center()
    local win = focusedWindow()
    if not win then return end

    local screenFrame = win:screen():frame()
    local f = win:frame()

    f.x = screenFrame.x + ((screenFrame.w - f.w) / 2)
    f.y = screenFrame.y + ((screenFrame.h - f.h) / 2)

    win:setFrame(f, 0)
end

function obj:start()
    self:stop()

    local mods = { "cmd", "ctrl", "alt" }

    bindAndStore(self, mods, "h", function()
        self:move(-self.moveStep, 0)
    end)

    bindAndStore(self, mods, "l", function()
        self:move(self.moveStep, 0)
    end)

    bindAndStore(self, mods, "k", function()
        self:move(0, -self.moveStep)
    end)

    bindAndStore(self, mods, "j", function()
        self:move(0, self.moveStep)
    end)

    -- Resize like GlazeWM-style u/i/o/p
    bindAndStore(self, mods, "u", function()
        self:resize(-self.resizeStep, 0) -- shrink width
    end)

    bindAndStore(self, mods, "p", function()
        self:resize(self.resizeStep, 0) -- grow width
    end)

    bindAndStore(self, mods, "i", function()
        self:resize(0, -self.resizeStep) -- shrink height
    end)

    bindAndStore(self, mods, "o", function()
        self:resize(0, self.resizeStep) -- grow height
    end)

    -- bindAndStore(self, mods, "-", function()
    --   self:resize(-self.resizeStep, 0)
    -- end)
    --
    -- bindAndStore(self, mods, "=", function()
    --   self:resize(self.resizeStep, 0)
    -- end)
    --
    -- bindAndStore(self, { "cmd", "ctrl", "alt", "shift" }, "-", function()
    --   self:resize(0, -self.resizeStep)
    -- end)
    --
    -- bindAndStore(self, { "cmd", "ctrl", "alt", "shift" }, "=", function()
    --   self:resize(0, self.resizeStep)
    -- end)

    bindAndStore(self, mods, "c", function()
        self:center()
    end)

    return self
end

function obj:stop()
    for _, hotkey in ipairs(self.hotkeys) do
        hotkey:delete()
    end

    self.hotkeys = {}

    return self
end

return obj
