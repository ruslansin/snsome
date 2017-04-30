local awful = require("awful")
local gui = require("gui")

local function init()
    awful.screen.connect_for_each_screen(gui.builder)
end

return {
    init = init
}