local VK_JIS_EISUU = 0x66
local VK_JIS_KANA = 0x68
local VK_JIS_YEN = 0x5d

function flagsMatches(flags, modifiers)
    local set = {}
    for _, k in ipairs(modifiers) do set[string.lower(k)] = true end
    for _, k in ipairs({'fn', 'cmd', 'ctrl', 'alt', 'shift'}) do
        if set[k] ~= flags[k] then return false end
    end
    return true
end

local kana = false
local function handleEvent(e)
   local keyCode = e:getKeyCode()
   local flags = e:getFlags()
   local keyUp = (e:getType() == hs.eventtap.event.types.keyUp)
   local result = false
   if keyCode == VK_JIS_KANA then
      if kana then
	 --if keyUp then
	 --   hs.eventtap.keyStroke({}, VK_JIS_EISUU)
	 --end
	 --result = true
	 e:setKeyCode(VK_JIS_EISUU)
      end
      if keyUp then
	 kana = not kana
      end
   elseif keyCode == VK_JIS_YEN then
        if flagsMatches(flags, {'alt'}) then
            e:setFlags({})
        elseif flagsMatches(flags, {}) then
            e:setFlags({alt=true})
        end
   end
   return result
end

eventtap = hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, handleEvent)
eventtap:start()

local log = hs.logger.new("init", "debug")

local function keyCode(modifiers, key)
   modifiers = modifiers or {}
   key = string.lower(key)
   return function()
      hs.eventtap.event.newKeyEvent(modifiers, key, true):post()
      hs.timer.usleep(1000)
      hs.eventtap.event.newKeyEvent(modifiers, key, false):post()
      log.i(key)
   end
end

local function spotlight()
   local sc = [[
tell application "System Events"
    key code 103 using control down
end tell
]]
   hs.osascript.applescript(sc)
   log.i(sc)
end

--hs.hotkey.bind({}, "f11", spotlight, nil, nil)
