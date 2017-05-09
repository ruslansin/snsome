local utils = require("menubar.utils")
local spawn = require("awful.spawn")

local autostart = {}

function autostart.process(apps)
	for _, v in pairs(apps) do
		local terminal = v.Terminal or "unknown"
		local cmdline = v.cmdline
		if (terminal == "true") then
			spawn.with_shell(cmdline)
		else
			spawn.spawn(cmdline)
		end
	end
end

function autostart.run()
	local dir = string.format("%s/.config/autostart", os.getenv("HOME"))
	utils.parse_dir(dir, autostart.process)
end

return autostart