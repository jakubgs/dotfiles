-- Author: Jakub Sokołowski <panswiata@gmail.com>
-- Source: https://github.com/PonderingGrower/dotfiles

-- {{{ Standard awesome libraries
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Widgets and layouts
local naughty = require('naughty')

-- Load Debian menu entries
require("debian.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}
-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}
-- {{{ Variable definitions
homedir = os.getenv("HOME")

-- Run the autostart script
awful.spawn.with_shell(homedir .. "/bin/autostart")

-- Themes define colours, icons, and wallpapers
beautiful.init(homedir .. "/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
browser = "chromium"
hipchat = "hipchat"
fmanager = "thunar"
terminal = "urxvtc"

function term(command, name, args)
    args = args or ''
    name = name or command:match("([^%s]+)")
    cmd = terminal .. " " .. args .. " -name '"..name.."' -title '"..name.."' -e '"..command.."'"
    print(cmd)
    return cmd
end

geditor = term('nvim')
ncmpcpp = term('ncmpcpp')
fpass   = term(homedir .. '/bin/fpass', 'fpass', '-hold')

naughty.config.padding = 10
naughty.config.spacing = 6

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- for usage with awesome-client
newline = '\n'

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
    awful.layout.suit.max,              -- 1
    awful.layout.suit.tile,             -- 3
    awful.layout.suit.tile.left,        -- 4
    awful.layout.suit.tile.bottom,      -- 5
    awful.layout.suit.tile.top,         -- 6
    --awful.layout.suit.fair,             -- 7
    --awful.layout.suit.fair.horizontal,  -- 8
    --awful.layout.suit.corner.sw,        -- 9
}
-- }}}
-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = { ":admin:", ":edit:", ":web:", ":comm:", ":music:", ":fs:", ":net:", ":game:" }

-- }}}
-- {{{ Menu
-- Create a laucher widget and a main menu
mysystemmenu = {
    { "edit rc.lua",    geditor .. awful.util.getdir("config") .. "/rc.lua" },
    { "e: xorg.conf",   "gksudo " .. geditor .. " /etc/X11/xorg.conf" },
    { "---------------",     nil },
    { "sysmon",         "gnome-system-monitor" },
    { "palimpsest",     "gksudo palimpsest" },
    { "disk usage",     "baobab" },
    { "---------------",     nil },
    { "autostart",  term(homedir .. "/bin/autostart", 'autostart', ' -g 40x11 -hold') },
    { "restart",    awesome.restart },
    { "quit",       awesome.quit },
    { "lock",       "xlock" },
    { "shutdown",   "bin/zenity-wrapper Shutdown    \"sudo poweroff\"" },
    { "reboot",     "bin/zenity-wrapper Reboot      \"sudo reboot\"" },
    { "boot to win","bin/zenity-wrapper \"Boot into Windows\" \"~/bin/windows\"" }
}

myofficemenu = {
    { "libreoffice", "libreoffice" },
    { "------------", nil },
    { "writer",     "libreoffice --writer" },
    { "calc",       "libreoffice --calc" },
    { "draw",       "libreoffice --draw" },
    { "impress",    "libreoffice --impress" },
    { "math",       "libreoffice --math" }
}

mymainmenu = awful.menu({ items = {
    { "debian",     debian.menu.Debian_menu.Debian, beautiful.awesome_icon },
    { "system",     mysystemmenu, beautiful.awesome_icon },
    { "systools",   mystoolsmenu, beautiful.awesome_icon },
    { "office",     myofficemenu, beautiful.awesome_icon },
    { "-------------", nil },
    { "chromium",    browser },
    { "rutorrent",  "dwb" },
    { "-------------", nil },
    { "file manager",   fmanager },
    { "urxvt",      terminal },
    { "htop",       term('htop') },
    { "ncmpcpp",    ncmpcpp },
    { "remmina",    "remmina" },
    { "pidgin",     "pidgin" },
}
})

mylauncher = awful.widget.launcher({
    image = awesome.load_image(beautiful.awesome_icon),
    menu = mymainmenu
})
-- }}}
-- {{{ Wibox

-- Create a textclock widget
mytextclock = wibox.widget.textclock(" | %Y/%m/%d %H:%M:%S |", 1 )

-- Create battery widget
local bat_widget = nil
--local battery_widget = require("battery-widget")
--bat_widget = battery_widget {
--    adapter = "BAT0", ac = "AC",
--    battery_prefix = " Bat: ", ac_prefix = " AC: ",
--    percent_colors = {{25, "red"}, {50, "orange"}, {999, "#afd700"}},
--    tooltip_text = "${state}${time_est}",
--    widget_font = "terminus 12",
--}

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
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
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag(tags, s, awful.layout.suit.max)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
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
            s.mylayoutbox,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            bat_widget,
            mytextclock,
            wibox.widget.systray(),
        },
    }
end)

-- }}}
-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 2, function () awful.spawn(fmanager) end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))
-- }}}
-- {{{ Key bindings
globalkeys = awful.util.table.join(
awful.key({ modkey,           }, "Escape",    awful.tag.history.restore),
awful.key({ modkey,           }, "`",         awful.tag.history.restore),
awful.key({ modkey, "Shift"   }, "Tab",       function () focusby(-1)  end),
awful.key({ modkey,           }, "Tab",       function () focusby( 1)  end),
-- Layout manipulation
awful.key({ modkey,           }, "h",         function () awful.client.focus.global_bydirection("left") end),
awful.key({ modkey,           }, "l",         function () awful.client.focus.global_bydirection("right") end),
awful.key({ modkey,           }, "k",         function () awful.client.focus.global_bydirection("up") end),
awful.key({ modkey,           }, "j",         function () awful.client.focus.global_bydirection("down") end),
awful.key({ modkey, "Shift"   }, "k",         function () awful.client.swap.byidx( -1) end),
awful.key({ modkey, "Shift"   }, "j",         function () awful.client.swap.byidx(  1) end),
-- Run or raise
awful.key({ modkey,           }, "z",         function () run_or_raise("zeal", { class = "Zeal" }) end),
awful.key({ modkey,           }, "n",         function () run_or_raise(terminal .. " -name ranger -title ranger -e ranger ", { name = "ranger" }) end),
awful.key({ modkey,           }, "e",         function () run_or_raise(geditor, { name = "nvim" }) end),
awful.key({ modkey,           }, "w",         function () run_or_raise(browser, { class = "Chromium" }) end),
awful.key({ modkey, "Shift"   }, "c",         function () run_or_raise(terminal, { class = "URxvt" }) end),
awful.key({ modkey,           }, "p",         function () run_or_raise(fpass, { class = "fpass" }) end),
awful.key({ modkey,           }, "m",         function () run_or_raise(ncmpcpp, { instance = "ncmpcpp" }) end),
awful.key({ modkey, "Shift"   }, "m",         function () awful.spawn(homedir.."/bin/fmpd -r") end),
awful.key({ modkey,           }, "u",         function () run_or_raise("geary", { class = "Geary" }) end),
awful.key({ modkey,           }, "i",         function () run_or_raise(homedir.."/bin/status", { class = "Status" }) end),
--- Power & Screen
awful.key({ "Mod4", "Control" }, "s",         function () awful.spawn("sudo /usr/sbin/pm-suspend") end),
awful.key({ "Mod4", "Control" }, "h",         function () awful.spawn("sudo /usr/sbin/pm-hibernate") end),
awful.key({ "Mod4", "Control" }, "Left",      function () awful.spawn("xrandr --orientation left") end),
awful.key({ "Mod4", "Control" }, "Right",     function () awful.spawn("xrandr --orientation right") end),
awful.key({ "Mod4", "Control" }, "Up",        function () awful.spawn("xrandr --orientation normal") end),
awful.key({ "Mod4", "Control" }, "Down",      function () awful.spawn("xrandr --orientation inverted") end),
--- Standard program
awful.key({ modkey,           }, "c",         function () awful.spawn(terminal) end),
awful.key({ "Control",        }, "BackSpace", function () awful.spawn(terminal) end),
awful.key({ "Control", "Shift"}, "BackSpace", function () awful.spawn(terminal) end),
awful.key({ modkey, "Control" }, "r",         awesome.restart),
awful.key({ modkey, "Control" }, "q",         awesome.quit),
awful.key({ modkey, "Control" }, "h",         function () awful.tag.incncol( 1)         end),
awful.key({ modkey, "Control" }, "l",         function () awful.tag.incncol(-1)         end),
awful.key({ modkey,           }, "space",     function () awful.layout.inc(layouts,  1) end),
awful.key({ modkey, "Shift"   }, "space",     function () awful.layout.inc(layouts, -1) end),
-- Poker II Fn keys
awful.key({ "Mod4",           }, "Tab",       function () awful.tag.viewnext(mouse.screen) end),
awful.key({ "Mod4", "Shift"   }, "Tab",       function () awful.tag.viewprev(mouse.screen) end),
-- Prompt
awful.key({ modkey,           }, "R",         function () mypromptbox[mouse.screen]:run() end),
awful.key({ modkey            }, "r",         function () awful.spawn("rofi -show combi") end),
awful.key({ modkey            }, "Return",    function () awful.spawn("rofi -show combi") end),
awful.key({ modkey            }, "t", function ()
        awful.prompt.run({ prompt = "killall: " },
        awful.screen.focused().mypromptbox.widget,
        function (s)
            awful.spawn(terminal .. " -e 'killall " .. s .. "'")
        end,
        homedir .. "/.awesome/killall_history")
    end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "q",
        function (c)
            c:kill()
        end,
        {description = "close", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "a",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey,           }, "s",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Shift"   }, "h",
        function (c)
            c:move_to_screen(c.screen.index+1)
        end,
        {description = "move to screen +1", group = "client"}),
    awful.key({ modkey, "Shift"   }, "l",
        function (c)
            c:move_to_screen(c.screen.index-1)
        end,
        {description = "move to screen -1", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))


-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            titlebars_enabled = false,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA",  -- Firefox addon DownThemAll.
            "copyq",  -- Includes session name in class.
        },
        class = {
            "feh",
            "Arandr",
            "Screenkey",
            "pinentry",
            "Thunar",
        },
        role = {
            "AlarmWindow",  -- Thunderbird's calendar.
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Games
    { rule_any = { class = {"csgo_linux64"}
      }, properties = { ontop = true, minimized = false, hidden = false, fullscreen = true }},
    { rule_any = { class = {"VirtualBox*"}
      }, properties = { minimized = false, hidden = false, fullscreen = true }},

    -- fpass
    { rule = { name = "fpass" },
        properties = { floating = true, height = 1000 },
        callback = function(c) awful.placement.centered(c) end
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "dialog" }, name = { "mpv.*" } },
         properties = { titlebars_enabled = true } },

    -- Screen/tag allocation
    { rule_any = { class = { "mmtail", "ytdl" } },
        properties = { screen = 1, tag = ":admin:" } },
    { rule_any = { name = { "nvim" } },
        properties = { screen = 1, tag = ":edit:" } },
    { rule_any = { class = { "Iceweasel", "Chromium" } },
        properties = { screen = 1, tag = ":web:" } },
    { rule_any = { class = { "ncmpcpp" }, name = { "ncmpcpp*" }, },
        properties = { screen = 1, tag = ":music:" } },
    { rule_any = { class = { "Status", "Slack", "Skype", "Geary" } },
        properties = { screen = 1, tag = ":comm:" } },
    { rule_any = { name = { "ranger" } },
        properties = { screen = 1, tag = ":fs:" } },
    { rule_any = { name = { "Transmission" } },
        properties = { screen = 1, tag = ":net:" } },
    { rule_any = { class = { "Steam", "csgo_linux64" } },
        properties = { screen = 1, tag = ":game:" } },
}
-- }}}
-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    -- remove gaps -- IMPORTANT!!
    c.size_hints_honor = false

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- {{{ Custom functions

-- Find a client based on properties
function run_or_raise(cmd, rule)
    local matcher = function (c)
        return awful.rules.match(c, rule)
    end
    awful.client.run_or_raise(cmd, matcher)
end

-- Function for focusing
function focusby(count)
    awful.client.focus.byidx( count)
    if client.focus then client.focus:raise() end
end
-- }}}
