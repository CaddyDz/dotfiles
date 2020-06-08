# Initialize Hammer Spoon
mkdir -p ~/.hammerspoon
cat <<EOH > ~/.hammerspoon/init.lua
hs.window.animationDuration = 0
units = {
  right   = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left    = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  top     = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bottom  = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  maximum = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}
hs.hotkey.bind('cmd', 'up', function() hs.window.focusedWindow():move(units.maximum,  nil, true) end)
hs.hotkey.bind('cmd', 'down', function() hs.window.focusedWindow():move(units.bottom, nil, true) end)
hs.hotkey.bind('cmd', 'left', function() hs.window.focusedWindow():move(units.left,   nil, true) end)
hs.hotkey.bind('cmd', 'right', function() hs.window.focusedWindow():move(units.right, nil, true) end)
EOH