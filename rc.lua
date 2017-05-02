local window = require("window").init()

local keys = require("window.keys").init()

local rules = require("window.rules").init(
    {
        clientkeys = keys.client.clientkeys,
        clientbuttons = keys.client.clientbuttons
    }
)