local awful = require("awful");
local beautiful = require("beautiful")

local function init(args)
  local args = args or {}
  local clientkeys = args.clientkeys
  local clientbuttons = args.clientbuttons
  
  awful.rules.rules = {
      { rule = {},
        properties = { border_width = beautiful.border_width,
                       border_color = beautiful.border_normal,
                       focus = awful.client.focus.filter,
                       raise = true,
                       keys = clientkeys,
                       buttons = clientbuttons,
                       screen = awful.screen.preferred,
                       placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
      },
      { rule_any = {
          instance = {
            "DTA",  -- Firefox addon DownThemAll.
            "copyq",  -- Includes session name in class.
          },
          class = {
            "Arandr",
            "Gpick",
            "Kruler",
            "MessageWin",  -- kalarm.
            "Sxiv",
            "Wpa_gui",
            "pinentry",
            "veromix",
            "xtightvncviewer"},

          name = {
            "Event Tester",  -- xev.
          },
          role = {
            "AlarmWindow",  -- Thunderbird's calendar.
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          }
        }, properties = { floating = true }},

      -- Add titlebars to normal clients and dialogs
      { rule_any = {type = { "normal", "dialog" }
        }, properties = { titlebars_enabled = true }
      },

      -- Set Firefox to always map on the tag named "2" on screen 1.
      -- { rule = { class = "Firefox" },
      --   properties = { screen = 1, tag = "2" } },
  }
end

return {
  init = init
}