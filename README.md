## SNSOME

### Decription 
Theme for Awesome WM 4.x

### Installation

```shell
git clone --recursive https://github.com/snqlby/snsome.git
mv -bv snsome/* ~/.config/awesome; rm -r snsome
```

### Usage example (rc.lua)

```Lua
local spawn = require("awful.spawn")
local theme = require("beautiful")
local autostart = require("utils.autostart")

-- mail configuration (optional)
theme.mail = {
	timeout = 30,
	server = "IMAP_SERVER",
	login = "YOUR_LOGIN",
	password = "PASSWORD"
}

--checkupdate widget configuration (optional)
theme.updates = {
	timeout = 60,
	distro = "arch_pacaur",
	onclick = function()
		spawn("urxvt -hold -e sh -c 'pacaur -Syu'") 
	end
}

-- menu configuration (optional)
theme.menu_skip = {
	"Avahi", "urxvt", "Network Co", "V4L2", "OpenJDK"
}

-- init theme (required)
require("init") 

-- autostart all apps from "$HOME/.config/autostart" directory (optional)
autostart.run()

```

### Additional configuration: .Xresources

```
!snsome configuration (default values)
snsome.terminal: xterm
snsome.editor: nano
snsome.modkey: Mod4
snsome.theme: default
```
