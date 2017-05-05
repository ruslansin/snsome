local utils = require("menubar.utils")
local awful = require("awful")

local autostart = {}

function autostart.process(apps)
	for _, v in pairs(apps) do
		local terminal = v.Terminal or "unknown"
		local cmdline = v.cmdline
		if (terminal == "true") then
			awful.with_shell(cmdline)
		else
			awful.spawn(cmdline)
		end
	end
end

function autostart.run()
	local dir = string.format("%s/.config/autostart", os.getenv("HOME"))
	utils.parse_dir(dir, autostart.process)
end

return autostart