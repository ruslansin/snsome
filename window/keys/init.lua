local global = require("window.keys.global");
local client = require("window.keys.client");

local keys = {
	modkey = awesome.xrdb_get_value("", "snsome.modkey") or "Mod4"
}

local function init()
	return
	{
	    global = global.init(keys),
	    client = client.init(keys)
	}
end

return {
	init = init
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80