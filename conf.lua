function love.conf(t)
    t.version = "11.0"
    t.window.title = "LD46"
    t.window.width = 1024
    t.window.height = 768
    --t.window.fullscreen = true -- Do not fullscreen since we lack an exit button.
    t.window.resizable = false
    --t.window.icon = "Images/icon.png"

    t.modules.joystick = false
end
