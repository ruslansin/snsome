local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")
local utils = require("window.utils")
local hotkeys_popup = require("awful.hotkeys_popup").widget

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

local function builder(s)

	local terminal = awesome.xrdb_get_value("", "snsome.terminal") or "xterm";
    local editor = awesome.xrdb_get_value("", "snsome.editor") or os.getenv("EDITOR") or "nano";
    local editor_cmd = terminal .. " -e " .. editor


    -- Table of layouts to cover with awful.layout.inc, order matters.
    awful.layout.layouts = {
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.top,
        -- awful.layout.suit.fair,
        -- awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
    }
    -- }}}

    -- {{{ Menu
    -- Create a launcher widget and a main menu
    myawesomemenu = {
        { "hotkeys", function() return false, hotkeys_popup.show_help end },
        { "manual", terminal .. " -e man awesome" },
        { "edit config", editor_cmd .. " " .. awesome.conffile },
        { "restart", awesome.restart },
        { "quit", function() awesome.quit() end }
    }

    mymainmenu = awful.menu({ 
        items = { 
            { "awesome", myawesomemenu, beautiful.awesome_icon },
            { "open terminal", terminal }
        }
    })

    mylauncher = awful.widget.launcher({ 
        image = beautiful.awesome_icon,
        menu = mymainmenu 
    })

    -- Menubar configuration
    menubar.utils.terminal = terminal -- Set the terminal for applications that require it
    -- }}}

    -- Keyboard map indicator and switcher
    mykeyboardlayout = awful.widget.keyboardlayout()

    -- {{{ Wibar
    -- Create a textclock widget
    mytextclock = wibox.widget.textclock()

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
        end))


	-- Wallpaper
    utils.set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(
        gears.table.join(
          awful.button({}, 1, function () awful.layout.inc( 1) end),
          awful.button({}, 3, function () awful.layout.inc(-1) end),
          awful.button({}, 4, function () awful.layout.inc( 1) end),
          awful.button({}, 5, function () awful.layout.inc(-1) end)
        ) 
    )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }



    -- {{{ Mouse bindings
    root.buttons(gears.table.join(
        awful.button({}, 3, function () 
            mymainmenu:toggle() 
        end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    ))
    -- }}}
end

return {
	builder = builder
}