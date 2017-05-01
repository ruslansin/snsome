local awful = require("awful")
local beautiful = require("beautiful")
local utils = require("window.utils")


local function init()
    client.connect_signal("manage", function (c)
        if awesome.startup and
          not c.size_hints.user_position
          and not c.size_hints.program_position then
            awful.placement.no_offscreen(c)
        end
    end)

    client.connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- client.connect_signal("focus", function(c)
    --         if c.maximized then
    --             c.border_width = 0
    --         elseif #awful.screen.focused().clients > 1 then
    --             c.border_width = beautiful.border_width
    --             c.border_color = beautiful.border_focus
    --         end
    -- end)
    
    client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
    client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

    screen.connect_signal("property::geometry", utils.set_wallpaper)
end

return {
    init = init
}