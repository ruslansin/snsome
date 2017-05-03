local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local theme = require("beautiful")
local menubar = require("menubar")
local utils = require("window.utils")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local freedesktop = require("freedesktop")
local lain = require("lain")

local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ 
                theme = { 
                    width = 250 
                } 
            })
        end
    end
end

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

local terminal = awesome.xrdb_get_value("", "snsome.terminal") or "xterm"
local editor = awesome.xrdb_get_value("", "snsome.editor") or os.getenv("EDITOR") or "nano"
local editor_cmd = terminal .. " -e " .. editor
local modkey = awesome.xrdb_get_value("", "snsome.modkey") or "Mod4"
local markup = lain.util.markup

-- {{{ Menu
local awesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}

local mainmenu = freedesktop.menu.build({
    icon_size = theme.menu_height or 16,
    before = {
        { "Awesome", awesomemenu, theme.awesome_icon },
    },
    after = {
        { "Open terminal", terminal },
    },
    skip_items = {"Avahi", "urxvt", "Network Co", "V4L2"}
})

awful.util.mainmenu = mainmenu

local launcher_widget = awful.widget.launcher({ 
    image = theme.menu_icon,
    menu = mainmenu 
})

local volumebox = lain.widget.pulseaudio({
    settings = function()
        local current_volume = "N/A"
        if volume_now.left == volume_now.right then
            current_volume = string.format("%s%%", volume_now.left)
        else
            current_volume = string.format("l.%s|r.%s%%", volume_now.left, volume_now.right)
        end
        if volume_now.muted == "yes" then
            current_volume = string.format("%s mute", current_volume)
        end
        widget:set_markup(markup.fontfg(
            theme.font, theme.fg_normal, string.format(" V: %s ", current_volume)
        ))
    end
})

-- It is necessary to declare your own values in the theme.mail = {}
-- Mail IMAP check
local mail_widget = nil
if (theme.mail ~= nil) then
    mail_widget = lain.widget.imap({
        timeout  = theme.mail.timeout,
        server   = theme.mail.server,
        mail     = theme.mail.login,
        password = theme.mail.password,
        settings = function()
            widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, string.format(" M: %s ", mailcount)))
        end
    })
    mail_widget = mail_widget.widget
end

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


-- Keyboard map indicator and switcher
local keyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local textclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({}, 3, client_menu_toggle_fn()),
    awful.button({}, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function () 
        awful.util.mainmenu:toggle() 
    end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    utils.set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[2])

    -- Create a promptbox for each screen
    s.promptbox = awful.widget.prompt()

    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(
        gears.table.join(
          awful.button({}, 1, function () awful.layout.inc(1) end),
          awful.button({}, 3, function () awful.layout.inc(-1) end),
          awful.button({}, 4, function () awful.layout.inc(1) end),
          awful.button({}, 5, function () awful.layout.inc(-1) end)
        ) 
    )
    -- Create a taglist widget
    s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.topbox = awful.wibar({ position = "top", screen = s })
    s.topbox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            launcher_widget,
            s.taglist,
            s.promptbox,
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            mail_widget,
            wibox.widget.systray(),
            volumebox.widget,
            keyboardlayout,
            textclock
        }
    }

    -- bottom
    s.bottombox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = 20, bg = theme.bg_normal, fg = theme.fg_normal })
    s.bottombox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
        },
        s.tasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            s.layoutbox
        },
    }
end)