local function keyCode(key, modifiers)
   modifiers = modifiers or {}
   return function()
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
      hs.timer.usleep(1000)
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()      
   end
end

local function remapKey(modifiers, key, keyCode)
   hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

local function disableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:disable()
   end
end

local function enableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:enable()
   end
end

local function handleGlobalAppEvent(name, event, app)
   if event == hs.application.watcher.activated then
      -- hs.alert.show(name)
      if name ~= "iTerm2" then
         enableAllHotkeys()
      else
         disableAllHotkeys()
      end
   end
end

-- appsWatcher = hs.application.watcher.new(handleGlobalAppEvent)
-- appsWatcher:start()



-- カーソル移動
remapKey({}, 'home', keyCode('a', {'ctrl'}))
remapKey({}, 'end', keyCode('e', {'ctrl'}))

kana = false
local function handleKana()
    return function()
        local keycode = 104
        hs.eventtap.event.newKeyEvent({}, keycode, true):post()
        hs.timer.usleep(1000)
        hs.eventtap.event.newKeyEvent({}, keycode, false):post()
        kana = not kana
    end
end

--remapKey({}, 104, handleKana())
