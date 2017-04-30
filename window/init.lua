require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

local titlebar = require("window.titlebar")
local signals = require("window.signals")
local screen = require("window.screen")

-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

local function init()
	local current_theme = awesome.xrdb_get_value("", "snsome.theme") or "default"
	beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), current_theme))

	-- {{{ Error handling
	-- Check if awesome encountered an error during startup and fell back to
	-- another config (This code will only ever execute for the fallback config)
	if awesome.startup_errors then
	    naughty.notify({ 
	        preset = naughty.config.presets.critical,
	        title = "Oops, there were errors during startup!",
	        text = awesome.startup_errors 
	    })
	end

	-- Handle runtime errors after startup
	do
	    local in_error = false
	    awesome.connect_signal("debug::error", function (err)
	        -- Make sure we don't go into an endless error loop
	        if in_error then return end
	        in_error = true

	        naughty.notify({ 
	            preset = naughty.config.presets.critical,
	            title = "Oops, an error happened!",
	            text = tostring(err) 
	        })
	        in_error = false
	    end)
	end
	-- }}}

	titlebar.init()
	signals.init()
	screen.init()
end

return { 
	init = init
}