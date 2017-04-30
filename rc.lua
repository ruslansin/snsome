local workspace = require("window")
local rules = require("window.rules")
local keys = require("window.keys")


-- init workspace
workspace.init()
--init keys
local wmkeys = keys.init()
-- init rules
rules.init(wmkeys.clientkeys)
