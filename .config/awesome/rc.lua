-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local vicious = require("vicious")
vicious.widgets.mpd = require("vicious.widgets.mpd")
vicious.widgets.volume = require("vicious.widgets.volume")
-- Run the autostart script
awful.util.spawn_with_shell("~/bin/autostart")


-- {{{ Variable definitions
homedir = "/home/sochan/"
-- Themes define colours, icons, and wallpapers
beautiful.init(homedir .. ".awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
browser = "firefox"
fmanager = "thunar /mnt/melchior/torrent"
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,			--1
    awful.layout.suit.tile,				--2
    awful.layout.suit.tile.left,		--3
    awful.layout.suit.tile.bottom,		--4
    awful.layout.suit.tile.top,			--5
    awful.layout.suit.fair,				--6
    awful.layout.suit.fair.horizontal,	--7
    awful.layout.suit.max,				--8
    --awful.layout.suit.magnifier
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}

-- Each screen has its own tag table.
tags[1] = awful.tag({ ":admin:", ":web:", ":im:", ":files:", ":misc:", ":work:" }, 1, 
					{ layouts[2], layouts[8], layouts[2], layouts[3], layouts[2], layouts[8] })
tags[2] = awful.tag({ ":editor:", ":web:", ":mail:", ":images:", ":movies:", ":work:" }, 2, 
					{ layouts[2], layouts[8], layouts[5], layouts[8], layouts[1], layouts[8] })
tags[3] = awful.tag({ ":admin:", ":web:", ":music:", ":files:", ":misc:", ":work:" }, 3, 
					{ layouts[3], layouts[8], layouts[4], layouts[2], layouts[3], layouts[8] })
--end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
mysystemmenu = {
    { "autostart",	terminal .. " -g 40x11 -hold -e " .. homedir .. "bin/autostart" },
	{ "restart",	awesome.restart },
	{ "quit",		awesome.quit },
	{ "lock",		"xlock" },
	{ "shutdown",	"bin/zenity-wrapper Shutdown    \"sudo poweroff\"" },
	{ "reboot",		"bin/zenity-wrapper Reboot      \"sudo reboot\"" },
	{ "boot to win","bin/zenity-wrapper \"Boot into Windows\" \"~/bin/windows\"" }
}

myofficemenu = {
	{ "libreoffice", "libreoffice" },
	{ "------------", nil },
	{ "writer",		"libreoffice --writer" },
	{ "calc",		"libreoffice --calc" },
	{ "draw",		"libreoffice --draw" },
	{ "impress",	"libreoffice --impress" },
	{ "math",		"libreoffice --math" }
}

mystoolsmenu = {
        { "edit rc.lua",        "gvim " .. awful.util.getdir("config") .. "/rc.lua" },
	{ "edit xorg.conf",     "gksudo gvim " .. "/etc/X11/xorg.conf" },
        { "edit wallpaper",	"nitrogen /mnt/melchior/data/Wallpapers/" },
	{ "---------------",     nil },
        { "system monitor",	"gnome-system-monitor" },
	{ "palimpsest",         "gksudo palimpsest" },
        { "disk usage",	        "baobab" },
}

mygamesmenu = {
	{ "Starcraft II", "wine \"/mnt/stuff/Games/StarCraft II/StarCraft II.exe\"" },
}

myvmmenu = {
	{ "virtualbox", "VirtualBox" },
	{ "-------------", nil },
	{ "* Windows 7",    "VirtualBox --startvm \"Windows 7 on SSD\"" },
	{ "* Windows XP",   "VirtualBox --startvm \"Windows XP Pro\"" },
	{ "* Gentoo Test",  "VirtualBox --startvm \"Gentoo Testing System\"" }
}

mymelchiormenu = {
	{ "ssh", terminal .. " -e ssh melchior" },
	{ "htop", terminal .. " -e " .. homedir .. "bin/mhtop" },
	{ "mmtail", terminal .. " -e " .. homedir .. "bin/mmtail" },
	{ "mpd", "gmpc" }
}

mymainmenu = awful.menu({ items = { 
	{ "system",		mysystemmenu, beautiful.awesome_icon },
	{ "systools",	mystoolsmenu, beautiful.awesome_icon },
        { "melchior",	mymelchiormenu, beautiful.awesome_icon },
	{ "office",		myofficemenu, beautiful.awesome_icon },
	{ "games",		mygamesmenu, beautiful.awesome_icon },
	{ "vm",			myvmmenu, beautiful.awesome_icon },
	{ "-------------", nil },
	{ "firefox",	browser },
	{ "rutorrent",	"luakit http://melchior/rutorrent" },
	{ "thunderbird","thunderbird" },
	{ "-------------", nil },
	{ "file manager",	fmanager },
        { "urxvt",		terminal },
        { "urxvtb",		homedir .. "bin/urxvtb" },
	{ "htop",		terminal .. " -e htop" },
	{ "ncmpcpp",	terminal .. " -name ncmpcpp -e ncmpcpp" },
        { "brasero",	"brasero" },
        { "remmina",	"remmina" },
	{ "pidgin",		"pidgin" },
	{ "gmplayer",	"gnome-mplayer" },
}
                        })

mylauncher = awful.widget.launcher({ image = awesome.load_image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox

-- Create a textclock widget
mytextclock = awful.widget.textclock("| %a %b %d, %H:%M:%S |", 1 )

-- MPD status
-- Initialize widget
mympdwidget = wibox.widget.textbox()

-- Register widget
vicious.register(mympdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            return "| - Stopped - "
        else 
            return '| ' .. args["{state}"] .. ': ' .. args["{Artist}"]..' - '.. args["{Title}"] .. ' '
        end
    end, 1) -- refresh every 2 seconds

mympdwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("mpc toggle", false) end),
    awful.button({ }, 3, function () awful.util.spawn("mpc random", false) end),
    awful.button({ }, 4, function () awful.util.spawn("mpc next", false) end),
    awful.button({ }, 5, function () awful.util.spawn("mpc prev", false) end)
))
--mympdwidget.width = "400"

-- Volume bar
myvolume = wibox.widget.textbox()
vicious.register(myvolume, vicious.widgets.volume, "| Vol: $1% |", 1, "PCM")

myvolume:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(homedir .. "bin/mute", false) end),
    awful.button({ }, 3, function () awful.util.spawn(terminal .. " -e alsamixer", true) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q set PCM 2dB+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q set PCM 2dB-", false) end)
))

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  --c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end))
-- }}
for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    left_layout:add(mylayoutbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    if s == 2 then right_layout:add(mytextclock) end
    if s == 3 then right_layout:add(mympdwidget) end
    if s == 3 then right_layout:add(myvolume) end

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 2, function () awful.util.spawn(fmanager) end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))
-- }}}

-- Function for focusing
local function focusby(count)
  awful.client.focus.byidx( count)
  if client.focus then client.focus:raise() end
end

-- {{{ Key bindings
-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ "Mod4",			  }, "l",       function () awful.util.spawn("slock") end),
    awful.key({ "Mod4",			  }, "h",       function () awful.util.spawn("sudo hibernate") end),
    awful.key({ "Mod4",			  }, "w",       function () awful.util.spawn(homedir .. "bin/windows") end),
    awful.key({ modkey,           }, "`",	    awful.tag.history.restore),
    awful.key({ modkey, "Shift"   }, "Tab",     function () focusby(-1)  end),
    awful.key({ modkey,			  }, "Tab",     function () focusby( 1)  end),

    -- Layout manipulation
    -- VIM movement
    awful.key({ modkey,           }, "h",       function () awful.client.focus.global_bydirection("left") end),
    awful.key({ modkey,           }, "l",       function () awful.client.focus.global_bydirection("right") end),
    awful.key({ modkey,           }, "k",       function () awful.client.focus.global_bydirection("up") end),
    awful.key({ modkey,           }, "j",       function () awful.client.focus.global_bydirection("down") end),
    awful.key({ modkey,           }, "d",       function () awful.client.focus.history.previous() end),
    awful.key({ modkey, "Shift"   }, "k",       function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Shift"   }, "j",       function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "h",       function () awful.client.movetoscreen(client.focus ,client.focus.screen - 1) end),
    awful.key({ modkey, "Shift"   }, "l",       function () awful.client.movetoscreen(client.focus ,client.focus.screen + 1) end),
    --awful.key({ modkey,		    }, "h",       function () awful.screen.focus_relative(-1)	end),
    --awful.key({ modkey,	        }, "l",       function () awful.screen.focus_relative(1)	end),
    --awful.key({ modkey,           }, "k",       function () focusby(-1)  end),
	--awful.key({ modkey,           }, "j",       function () focusby( 1)  end),
    --awful.key({ modkey, "Shift"   }, "h",       function () awful.client.swap.global_bydirection("left") end),
    --awful.key({ modkey, "Shift"   }, "l",       function () awful.client.swap.global_bydirection("right") end),
    --awful.key({ modkey, "Shift"   }, "k",       function () awful.client.swap.global_bydirection("up") end),
    --awful.key({ modkey, "Shift"   }, "j",       function () awful.client.swap.global_bydirection("down") end),

    -- Run or raise
    awful.key({ modkey,           }, "e",       function () run_or_raise("gvim --servername GVIM", { class = "Gvim" }) end),
    awful.key({ modkey,           }, "w",       function () run_or_raise("firefox", { class = "Firefox" }) end),
    awful.key({ modkey,           }, "m",       function () run_or_raise(terminal .. " --name ncmpcpp -e ncmpcpp", { instance = "ncmpcpp" }) end),
    -- Standard program
    awful.key({ "Control","Shift" }, "BackSpace", function () awful.util.spawn(terminal) end),
    awful.key({ "Control",        }, "BackSpace", function () awful.util.spawn(homedir .. "bin/urxvtb") end),
    awful.key({ modkey, "Control" }, "r",       awesome.restart),
    awful.key({ modkey, "Control" }, "q",       awesome.quit),
    awful.key({ modkey, "Control" }, "h",		function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",		function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space",	function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space",	function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    --awful.key({ modkey },            "r",		obvious.popup_run_prompt.run_prompt)
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey },            "t",
            function ()
                    awful.prompt.run({ prompt = "killall: " },
                    mypromptbox[mouse.screen].widget,
                    function (s)
                            awful.util.spawn(terminal .. " -e killall " .. s)
                    end,
                    homedir .. ".awesome/killall_history")
            end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,			  }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey,			  }, "s",		awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,	"Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
	--awful.key({ modkey,           }, "w",      function () mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible   end),
    awful.key({ modkey,           }, "a",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
	awful.key({ modkey, "Shift" }, "t", function (c)
       if   c.titlebar then awful.titlebar.remove(c)
       else awful.titlebar.add(c, { modkey = modkey }) end
	end),
	awful.key({ modkey,			  }, "Escape", function ()
		-- If you want to always position the menu on the same place set coordinates
		awful.menu.menu_keys.down = { "Down", "Alt_L" }
		local cmenu = awful.menu.clients({width=245}, { keygrabber=true, coords={x=525, y=330} })
	end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
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
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     --floating = false,
                     keys = clientkeys,
                     buttons = clientbuttons, } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Spacefm" },
      properties = { floating = true, border = 5 } },
    { rule = { name = "File Operation Progress" },
      properties = { floating = true } },
    { rule = { name = "Zmiana nazwy*" },
      properties = { floating = true } },
    { rule = { name = "Wprowad*" },
      properties = { floating = true } },
    { rule = { class = "feh" },
      properties = { floating = true } },
    { rule = { class = "*Wine*" },
      properties = { floating = true } },
    { rule = { class = "libreoffice*" },
      properties = { floating = true } },
    --{ rule = { class = "VirtualBox" },
    --  properties = { tag = tags[2][6] } },
    { rule = { class = "Msgcompose" },
      properties = { floating = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2], floating = false } },
    { rule = { class = "Firefox", instance = "Zapisz*" },
	  callback = function(c) awful.client.movetotag(tags[mouse.screen][awful.tag.getidx()], c) end},
    { rule = { name = "Session Manager*" },
      properties = { floating = true } },
    { rule = { class = "luakit" },
      properties = { tag = tags[3][2] } },
    { rule = { instance = "ncmpcpp" },
      properties = { tag = tags[3][3] } },
    { rule = { name = "htop" },
      properties = { tag = tags[3][3] } },
    { rule = { name = "mhtop" },
      properties = { tag = tags[3][3] } },
    { rule = { name = "mmtail" },
      properties = { tag = tags[1][1] } },
    { rule = { name = "ffvim" },
      properties = {
                    floating = true,
					ontop = true,
                    --tag = tags[1][2],
                    } },
    { rule = { class = "Gvim" },
      properties = {
                    floating = false,
                    --size_hints_honor = false,
                    tag = tags[2][1],
                    } },
    { rule = { name = "StarCraft II.exe*" },
      properties = {
					tag = tags[2][4],
					floating = true,
					fullscreen = true,
					--ontop = true
					} },
    { rule = { name = "Windows 7 *" },
      properties = {
					tag = tags[2][6],
					floating = false,
					fullscreen = true,
					maximized_horizontal = true,
					maximized_vertical   = true
					} },
    { rule = { name = "Gentoo Testing System *" },
      properties = {
					tag = tags[3][6],
					floating = false,
					maximized_horizontal = true,
					maximized_vertical   = true
					} },
    { rule = { class = "Remmina" },
      properties = { 
					tag = tags[1][6],
					floating = false,
					maximized_horizontal = true,
					maximized_vertical   = true
					} },
    { rule = { class = "Evince" },
      properties = { 
					floating = false
					} },
	{ rule = { instance = "plugin-container" },
	  properties = { floating = true, fullscreen = true } },
    { rule = { class = "Pidgin" },
      properties = { floating = false, tag = tags[1][3] } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[2][3] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- remove gaps -- IMPORTANT!!
    c.size_hints_honor = false
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
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
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Custom functions
--- Spawns cmd if no client can be found matching properties
-- If such a client can be found, pop to first tag where it is visible, and give it focus
-- @param cmd the command to execute
-- @param properties a table of properties to match against clients.  Possible entries: any properties of the client object
function run_or_raise(cmd, properties)
   local clients = client.get()
   local focused = awful.client.next(0)
   local findex = 0
   local matched_clients = {}
   local n = 0
   for i, c in pairs(clients) do
      --make an array of matched clients
      if match(properties, c) then
         n = n + 1
         matched_clients[n] = c
         if c == focused then
            findex = n
         end
      end
   end
   if n > 0 then
      local c = matched_clients[1]
      -- if the focused window matched switch focus to next in list
      if 0 < findex and findex < n then
         c = matched_clients[findex+1]
      end
      local ctags = c:tags()
      if #ctags == 0 then
         -- ctags is empty, show client on current tag
         local curtag = awful.tag.selected()
         awful.client.movetotag(curtag, c)
      else
         -- Otherwise, pop to first tag client is visible on
         awful.tag.viewonly(ctags[1])
      end
      -- And then focus the client
      client.focus = c
      c:raise()
      return
   end
   awful.util.spawn(cmd)
end

-- Returns true if all pairs in table1 are present in table2
function match (table1, table2)
   for k, v in pairs(table1) do
      if table2[k] ~= v and not table2[k]:find(v) then
         return false
      end
   end
   return true
end

-- }}}
