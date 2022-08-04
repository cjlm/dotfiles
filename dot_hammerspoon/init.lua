
-- function chrome_active_tab_with_name(name)
--     return function()
--         hs.osascript.javascript([[
--               // below is javascript code
--               var chrome = Application('Google Chrome');
--               chrome.activate();
--               var wins = chrome.windows;
--               // loop tabs to find a web page with a title of <name>
--               function main() {
--                   for (var i = 0; i < wins.length; i++) {
--                       var win = wins.at(i);
--                       var tabs = win.tabs;
--                       for (var j = 0; j < tabs.length; j++) {
--                       var tab = tabs.at(j);
--                       tab.title(); j;
--                       if (tab.title().indexOf(']] .. name .. [[') > -1) {
--                               win.activeTabIndex = j + 1;
--                               return;
--                           }
--                       }
--                   }
--               }
--               main();
--               // end of javascript
--           ]])
--     end
-- end

-- Specify your combination (your hyperkey)
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- We use 0 to reload the configuration
hs.hotkey.bind(hyper, "0", function()
    hs.reload()
end)

hs.alert.show("Hammerspoon config loaded")

local applicationHotkeys = {
    c = 'com.google.Chrome',
    s = 'com.tinyspeck.slackmacgap',
    m = 'com.apple.MobileSMS',
    f = 'org.mozilla.firefox',
    t = 'com.sublimetext.4',
    p = 'com.apple.systempreferences',
    a = 'com.apple.ActivityMonitor',
    v = "com.microsoft.VSCode",
    w = 'com.workflowy.desktop',
    i = 'com.apple.music',
    o = 'md.obsidian',
    q = 'com.apple.finder',
    g = 'com.sublimemerge',
    space = 'net.kovidgoyal.kitty'
}

local This = {} -- Quickly move to and from a specific app

local previousApp = ""
function switchToAndFromApp(bundleID)
    local focusedWindow = hs.window.focusedWindow()
    if focusedWindow == nil then
        hs.application.launchOrFocusByBundleID(bundleID)
    elseif focusedWindow:application():bundleID() == bundleID then
        if previousApp == nil then
            hs.window.switcher.nextWindow()
        else
            previousApp:activate()
        end
    else
        previousApp = focusedWindow:application()
        hs.application.launchOrFocusByBundleID(bundleID)
    end
end

for key, appStr in pairs(applicationHotkeys) do
    hs.hotkey.bind(hyper, key, function()
        switchToAndFromApp(appStr)
    end)
end

function pingResult(object, message, seqnum, error)
    if message == "didFinish" then
        avg = tonumber(string.match(object:summary(), '/(%d+.%d+)/'))
        if avg == 0.0 then
            hs.alert.show("No network")
        elseif avg < 200.0 then
            hs.alert.show("Network good (" .. avg .. "ms)")
        elseif avg < 500.0 then
            hs.alert.show("Network poor(" .. avg .. "ms)")
        else
            hs.alert.show("Network bad(" .. avg .. "ms)")
        end
    end
end

hs.hotkey.bind(hyper, "=", function()
    hs.network.ping.ping("8.8.8.8", 1, 0.01, 1.0, "any", pingResult)
end)

local activator = hyper
local activatorPlus = {"ctrl", "alt", "cmd"}

-- window management

local obj={}
obj.__index = obj

-- Metadata
obj.name = "MiroWindowsManager"
obj.version = "1.1"
obj.author = "Miro Mannino <miro.mannino@gmail.com>"
obj.homepage = "https://github.com/miromannino/miro-windows-management"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- MiroWindowsManager.sizes
--- Variable
--- The sizes that the window can have. 
--- The sizes are expressed as dividend of the entire screen's size.
--- For example `{2, 3, 3/2}` means that it can be 1/2, 1/3 and 2/3 of the total screen's size
obj.sizes = {2, 3, 3/2}

--- MiroWindowsManager.fullScreenSizes
--- Variable
--- The sizes that the window can have in full-screen. 
--- The sizes are expressed as dividend of the entire screen's size.
--- For example `{1, 4/3, 2}` means that it can be 1/1 (hence full screen), 3/4 and 1/2 of the total screen's size
obj.fullScreenSizes = {1, 4/3, 2}

--- MiroWindowsManager.GRID
--- Variable
--- The screen's size using `hs.grid.setGrid()`
--- This parameter is used at the spoon's `:init()`
obj.GRID = {w = 24, h = 24}

obj._pressed = {
  up = false,
  down = false,
  left = false,
  right = false
}

function obj:_nextStep(dim, offs, cb)
  if hs.window.focusedWindow() then
    local axis = dim == 'w' and 'x' or 'y'
    local oppDim = dim == 'w' and 'h' or 'w'
    local oppAxis = dim == 'w' and 'y' or 'x'
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local screen = win:screen()

    cell = hs.grid.get(win, screen)

    local nextSize = self.sizes[1]
    for i=1,#self.sizes do
      if cell[dim] == self.GRID[dim] / self.sizes[i] and
        (cell[axis] + (offs and cell[dim] or 0)) == (offs and self.GRID[dim] or 0)
        then
          nextSize = self.sizes[(i % #self.sizes) + 1]
        break
      end
    end

    cb(cell, nextSize)
    if cell[oppAxis] ~= 0 and cell[oppAxis] + cell[oppDim] ~= self.GRID[oppDim] then
      cell[oppDim] = self.GRID[oppDim]
      cell[oppAxis] = 0
    end

    hs.grid.set(win, cell, screen)
  end
end

function obj:_nextFullScreenStep()
  if hs.window.focusedWindow() then
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local screen = win:screen()

    cell = hs.grid.get(win, screen)

    local nextSize = self.fullScreenSizes[1]
    for i=1,#self.fullScreenSizes do
      if cell.w == self.GRID.w / self.fullScreenSizes[i] and 
         cell.h == self.GRID.h / self.fullScreenSizes[i] and
         cell.x == (self.GRID.w - self.GRID.w / self.fullScreenSizes[i]) / 2 and
         cell.y == (self.GRID.h - self.GRID.h / self.fullScreenSizes[i]) / 2 then
        nextSize = self.fullScreenSizes[(i % #self.fullScreenSizes) + 1]
        break
      end
    end

    cell.w = self.GRID.w / nextSize
    cell.h = self.GRID.h / nextSize
    cell.x = (self.GRID.w - self.GRID.w / nextSize) / 2
    cell.y = (self.GRID.h - self.GRID.h / nextSize) / 2

    hs.grid.set(win, cell, screen)
  end
end

function obj:_moveNextScreenStep()
  if hs.window.focusedWindow() then
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local screen = win:screen()

    win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
  end
end

function obj:_fullDimension(dim)
  if hs.window.focusedWindow() then
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local screen = win:screen()
    cell = hs.grid.get(win, screen)

    if (dim == 'x') then
      cell = '0,0 ' .. self.GRID.w .. 'x' .. self.GRID.h
    else  
      cell[dim] = self.GRID[dim]
      cell[dim == 'w' and 'x' or 'y'] = 0
    end

    hs.grid.set(win, cell, screen)
  end
end

--- MiroWindowsManager:bindHotkeys()
--- Method
--- Binds hotkeys for Miro's Windows Manager
--- Parameters:
---  * mapping - A table containing hotkey details for the following items:
---   * up: for the up action (usually {hyper, "up"})
---   * right: for the right action (usually {hyper, "right"})
---   * down: for the down action (usually {hyper, "down"})
---   * left: for the left action (usually {hyper, "left"})
---   * fullscreen: for the full-screen action (e.g. {hyper, "f"})
---   * nextscreen: for the multi monitor next screen action (e.g. {hyper, "n"})
---
--- A configuration example can be:
--- ```
--- local hyper = {"ctrl", "alt", "cmd"}
--- spoon.MiroWindowsManager:bindHotkeys({
---   up = {hyper, "up"},
---   right = {hyper, "right"},
---   down = {hyper, "down"},
---   left = {hyper, "left"},
---   fullscreen = {hyper, "f"}
---   nextscreen = {hyper, "n"}
--- })
--- ```
function obj:bindHotkeys(mapping)
  hs.inspect(mapping)
  print("Bind Hotkeys for Miro's Windows Manager")

  hs.hotkey.bind(mapping.down[1], mapping.down[2], function ()
    self._pressed.down = true
    if self._pressed.up then 
      self:_fullDimension('h')
    else
      self:_nextStep('h', true, function (cell, nextSize)
        cell.y = self.GRID.h - self.GRID.h / nextSize
        cell.h = self.GRID.h / nextSize
      end)
    end
  end, function () 
    self._pressed.down = false
  end)

  hs.hotkey.bind(mapping.right[1], mapping.right[2], function ()
    self._pressed.right = true
    if self._pressed.left then 
      self:_fullDimension('w')
    else
      self:_nextStep('w', true, function (cell, nextSize)
        cell.x = self.GRID.w - self.GRID.w / nextSize
        cell.w = self.GRID.w / nextSize
      end)
    end
  end, function () 
    self._pressed.right = false
  end)

  hs.hotkey.bind(mapping.left[1], mapping.left[2], function ()
    self._pressed.left = true
    if self._pressed.right then 
      self:_fullDimension('w')
    else
      self:_nextStep('w', false, function (cell, nextSize)
        cell.x = 0
        cell.w = self.GRID.w / nextSize
      end)
    end
  end, function () 
    self._pressed.left = false
  end)

  hs.hotkey.bind(mapping.up[1], mapping.up[2], function ()
    self._pressed.up = true
    if self._pressed.down then 
        self:_fullDimension('h')
    else
      self:_nextStep('h', false, function (cell, nextSize)
        cell.y = 0
        cell.h = self.GRID.h / nextSize
      end)
    end
  end, function () 
    self._pressed.up = false
  end)

  hs.hotkey.bind(mapping.fullscreen[1], mapping.fullscreen[2], function ()
    self:_nextFullScreenStep()
  end)

  hs.hotkey.bind(mapping.nextscreen[1], mapping.nextscreen[2], function ()
    self:_moveNextScreenStep()
  end)

end

hs.grid.setGrid(obj.GRID.w .. 'x' .. obj.GRID.h)
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

obj:bindHotkeys({
  up = {hyper, "up"},
  right = {hyper, "right"},
  down = {hyper, "down"},
  left = {hyper, "left"},
  fullscreen = {hyper, "return"},
  nextscreen = {hyper, "n"}
})
