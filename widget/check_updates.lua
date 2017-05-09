local awful = require("awful")
local helpers = require("lain.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")

local function factory(args)
    local cmds = {
    	arch_default = { cmd = "pacman -Qu", sl = 0	},
    	arch_checkupdates = { cmd = "checkupdates", sl = 0 },
        arch_pacaur = { cmd = "pacaur -Qu", sl = 0 },
        arch_yaourt = { cmd = "yaourt -Qu --aur", sl = 0 },
    	debian = { cmd = "apt-show-versions -u -b", sl = 0 },
    	ubuntu = { cmd = "aptitude search ~U", sl = 0 },
    	fedora = { cmd = "dnf list updates", sl = 3 },
    	freebsd = { cmd = "pkg_version -I -l '<'", sl = 0 },
    	mandriva = { cmd = "urpmq --auto-select", sl = 0 }
	}

	local checkupdates  = { widget = wibox.widget.textbox() }
    local args        = args or {}
    local distro      = cmds[args.distro] ~= nil and args.distro 
						or "arch_default"
    local timeout     = args.timeout or 60
    local custom      = args.custom
    local onclick     = args.onclick or function() end
    local settings    = args.settings or function() end
    local scallback   = args.scallback

    checkupdates.cmd = custom and custom.cmd or cmds[distro]["cmd"]
	checkupdates.sl = custom and custom.sl or cmds[distro]["sl"]

    function checkupdates.update()
    	if scallback then checkupdates.cmd = scallback() end

    	helpers.async({ shell, "-c", checkupdates.cmd }, function(s)
            updates = {
            	count = tonumber(select(2, s:gsub('\n', '\n'))) - checkupdates.sl
        	}

            widget = checkupdates.widget

            settings()
        end)
    end

    checkupdates.widget:connect_signal("button::release", function() onclick() end)

    helpers.newtimer("checkupdates", timeout, checkupdates.update)

    return checkupdates
end

return factory