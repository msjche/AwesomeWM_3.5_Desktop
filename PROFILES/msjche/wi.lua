-----------------------
-- AwesomeWM widgets --
--     by msjche	 --
-----------------------

local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require('awful.autofocus')
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local naughty = require("naughty")
local menubar = require("menubar")
local lain = require("lain")

home 			= os.getenv("HOME")
confdir 		= home .. "/.config/awesome"
scriptdir 		= confdir .. "/scripts/"
themes 			= confdir .. "/themes"
active_theme 	= themes .. "/msjche"
language 		= string.gsub(os.getenv("LANG"), ".utf8", "")

beautiful.init(active_theme .. "/theme.lua")

markup      = lain.util.markup
darkblue    = theme.bg_focus
white       = beautiful.fg_focus
blue        = "#7A5ADA"
arch_blue        = "#1793D0"
yellow		= "#E3E34E"
red         = "#EB8F8F"
gray        = "#858585"
border      = "#4A4A4A50"
background	= "#00000033"
bright_red  = "#FF0000"
green       = "#41F300"

widheight = 30
cpuwidth = 50
wifiwidth = 60

local util = awful.util

local tostring     = tostring
local string       = { format = string.format,
                       gsub   = string.gsub,
                       match  = string.match }
local math         = { floor  = math.floor }

----------------------------------------------------------------------------------------
-- Launchers
launcher_dir = active_theme .. "/icons/launchers/"
icon_dir = active_theme .. "/icons/"

mymainmenu = awful.menu.new({ items = require("menugen").build_menu(),
                              theme = { height = 25, width = 200 }})
mylauncher = awful.widget.launcher({ image = icon_dir .. "awesome_icon.png",
                                     menu = mymainmenu })

Default_launcher= awful.widget.launcher({ image = launcher_dir .. "tux.png", command = home .. "/Scripts/Theming/default.sh" })
virtualbox_launcher= awful.widget.launcher({ image = launcher_dir .. "tux.png", command = "VirtualBox" })
thunar_launcher= awful.widget.launcher({ image = launcher_dir .. "thunar.png", command = "thunar" })
SSR_launcher= awful.widget.launcher({ image = launcher_dir .. "SSR.png", command = "simplescreenrecorder" })
torbrowser_launcher = awful.widget.launcher({ image = launcher_dir .. "tor.png", command = "tor-browser-en" })
steam_launcher = awful.widget.launcher({ image = launcher_dir .. "steam.png", command = "/home/msjche/Scripts/steam.sh" })
libreoffice_launcher = awful.widget.launcher({ image = launcher_dir .. "libreoffice.png", command = "libreoffice" })
thunderbird_launcher = awful.widget.launcher({ image = launcher_dir .. "thunderbird.png", command = "thunderbird-bin" })
kill_launcher = awful.widget.launcher({ image = launcher_dir .. "kill.png", command = "/home/msjche/Scripts/minimal.sh" })
up_launcher = awful.widget.launcher({ image = launcher_dir .. "up.png", command = "/home/msjche/Scripts/up.sh" })
hud_launcher = awful.widget.launcher({ image = launcher_dir .. "hud.png", command = "/home/msjche/Scripts/up.sh" })
gimp_launcher = awful.widget.launcher({ image = launcher_dir .. "gimp.png", command = "gimp" })
filezilla_launcher = awful.widget.launcher({ image = launcher_dir .. "filezilla.png", command = "filezilla" })
chrome_launcher = awful.widget.launcher({ image = launcher_dir .. "chrome.png", command = "google-chrome-stable" })
mkvtoolnix_launcher = awful.widget.launcher({ image = launcher_dir .. "mkvtoolnix.png", command = "mkvtoolnix-gui" })
firefox_launcher = awful.widget.launcher({ image = launcher_dir .. "firefox.png", command = "firefox" })
qutebrowser_launcher = awful.widget.launcher({ image = launcher_dir .. "qutebrowser.png", command = "qutebrowser" })
telegram_launcher= awful.widget.launcher({ image = launcher_dir .. "telegram.png", command = "telegram-desktop" })
pycharm_launcher= awful.widget.launcher({ image = launcher_dir .. "pycharm.png", command = "pycharm" })
skype_launcher= awful.widget.launcher({ image = launcher_dir .. "skype.png", command = "skype" })
youtube_dl= awful.widget.launcher({ image = launcher_dir .. "youtube.png", command = "/home/msjche/Scripts/youtube_download.sh" })

------------------------------------------------------------------------------------------
-- System Info

systemicon = wibox.widget.imagebox(beautiful.widget_system)
vicious.cache(vicious.widgets.os)

systemwidget = wibox.widget.textbox()
  systemwidget:set_align("left")
  vicious.register(systemwidget, vicious.widgets.os, markup(gray, "User ") ..markup(blue, "$3") .. markup(gray, " ┈ ") .. markup(gray, "Hostname ") .. markup(blue, "$4") .. markup(gray, " ┈ ") .. markup(gray, "System ") .. markup(blue, "$2"))

-- Initialize widget
entnow = awful.widget.graph()
-- Graph properties
entnow:set_width(80)
entnow:set_scale(true)
entnow:set_max_value(1000)
entnow:set_background_color(background)
entnow:set_border_color(border)
entnow:set_color(blue)
-- Register widget
vicious.register(entnow, vicious.widgets.dio, "$1")

----------------------------------------------------------------------------------------
-- Weather

yawn = lain.widgets.yawn(2513768,
{
    settings = function()
        yawn_notification_preset.fg = gray
    end
})

----------------------------------------------------------------------------------------
-- Coretemp

tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_markup(markup(blue, coretemp_now) .. markup(gray, "°C"))
    end
})


----------------------------------------------------------------------------------------
-- Gmail

mailicon = wibox.widget.imagebox(beautiful.widget_mail)
mailwidget = wibox.widget.textbox()
gmail_t = awful.tooltip({ objects = { mailwidget },})
vicious.register(mailwidget, vicious.widgets.gmail,
        function (widget, args)
        gmail_t:set_text(args["{subject}"])
        gmail_t:add_to_object(mailicon)
            return args["{count}"]
                 end, 120) 

     mailicon:buttons(awful.util.table.join(
         awful.button({ }, 1, function () awful.util.spawn("urxvt -e mutt", false) end)
     ))

----------------------------------------------------------------------------------------
-- Pianobar

pianobaricon = wibox.widget.imagebox(beautiful.widget_pianobar)
pianobaricon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell("urxvt -e ~/.config/pianobar/pianobar_headless.sh") end)))

pianobarwidth    = 100

pianobarwidget = wibox.widget.textbox()
vicious.register(pianobarwidget, vicious.widgets.mpd,
  function(widget, args)
	pianobaricon:set_image(beautiful.widget_pianobar)
	local f = io.popen("pgrep pianobar")

      f = io.open(os.getenv("HOME") .. "/.config/pianobar/isplaying")
      play_or_pause = f:read("*line")
      f:close()

      -- Current song
      f = io.open(os.getenv("HOME") .. "/.config/pianobar/artist")
      band = f:read("*line"):match("(.*)")
      f:close()

      f = io.open(os.getenv("HOME") .. "/.config/pianobar/title")
      song = f:read("*line"):match("(.*)")
      f:close()
 	  
	  f = io.open(os.getenv("HOME") .. "/.config/pianobar/nowplaying")
      text = f:read("*line"):match("(.*)")
      f:close()
      -- Paused
    if play_or_pause == "0" then
        pianobaricon:set_image(beautiful.widget_pause)
--		return markup(gray, band)
		return markup(gray, "")
    elseif play_or_pause == "1" then
        pianobarwidget.width = 0
		return markup(blue, band) .. markup(gray, " ") .. markup(white, song)
    else
      	-- Stopped
      	pianobarwidget.width = 0
      	pianobaricon:set_image(beautiful.widget_pianobar_stopped)
      	info = "..."
	  	band = ""
	  	song = ""
    end
  end, 3)

----------------------------------------------------------------------------------------
-- MPD

mpdicon = wibox.widget.imagebox(beautiful.widget_mpd)
mpdicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
mpdwidget = lain.widgets.mpd({
    settings = function()
        mpd_notification_preset.fg = gray
		mpdicon:set_image(beautiful.widget_mpd)
        artist = mpd_now.artist
        title  = mpd_now.title  .. " "
		mpdwidget:set_markup(markup(gray, " ") .. markup(blue, artist) .. markup(gray, " ") .. markup(white, title))
		

        if mpd_now.state == "pause" then
        	artist = mpd_now.artist
            title  = "paused"
			mpdicon:set_image(beautiful.widget_mpd_paused)
			mpdwidget:set_markup(markup(gray, ""))
        elseif mpd_now.state == "stop" then
            artist = ""
            title  = ""
			mpdicon:set_image(beautiful.widget_mpd)
        end
    end
})

----------------------------------------------------------------------------------------
-- File System

vicious.cache(vicious.widgets.fs)

-- Initialize widget
fshome = lain.widgets.fs({
    partition = "/home",
    settings  = function()
        fs_notification_preset.fg = gray
        fs_header = ""
        fs_p      = ""
		fs_ps	  = ""

        if fs_now.used >= 75 then
            fs_header = " Hdd "
            fs_p      = fs_now.used
			fs_ps	  = "%"
        end

        widget:set_markup(markup(gray, " ◘ ") .. markup(red, fs_header) .. markup(bright_red, fs_p) .. markup(gray, fs_ps))
    end
})

----------------------------------------------------------------------------------------
-- Memory

memicon = wibox.widget.imagebox(beautiful.widget_mem)
memicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("urxvt -e htop -s PERCENT_MEM", false) end)))
memwidget = lain.widgets.mem({
    settings  = function()
        mem_header = "mem "
        mem_u      = mem_now.used
        mem_t      = mem_now.total
        mem_p      = mem_now.percent
--        widget:set_markup(markup(blue, mem_u) .. markup(gray, "MB"))
        widget:set_markup(markup(gray, "  ") .. markup(blue, mem_u))
		widget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("urxvt -e htop -s PERCENT_MEM", false) end)))
    end
})

----------------------------------------------------------------------------------------
--WiFi

net_up = wibox.widget.imagebox(beautiful.widget_net_up)
vicious.cache(vicious.widgets.wifi)

net_down = wibox.widget.imagebox(beautiful.widget_net_down)
vicious.cache(vicious.widgets.wifi)

--vicious.cache(vicious.widgets.wifi)
vicious.cache(vicious.widgets.net)

-- Initialize widget
netdown = awful.widget.graph()
-- Graph properties
netdown:set_width(wifiwidth)
netdown:set_height(widheight)
netdown:set_scale(true)
netdown:set_max_value(20)
netdown:set_background_color(background)
netdown:set_border_color(border)
netdown:set_color(blue)
-- Register widget
vicious.register(netdown, vicious.widgets.net, "${eno1 down_kb}")

-- Initialize widget
netup = awful.widget.graph()
-- Graph properties
netup:set_width(wifiwidth)
netup:set_height(widheight)
netup:set_scale(true)
netup:set_max_value(5)
netup:set_background_color(background)
netup:set_border_color(border)
netup:set_color(blue)
-- Register widget
vicious.register(netup, vicious.widgets.net, "${eno1 up_kb}")

----------------------------------------------------------------------------------------
-- VPN

vpnwidget = wibox.widget.textbox()
vpnwidget:set_text("  VPN")
vpnwidgettimer = timer({ timeout = 5 })
vpnwidgettimer:connect_signal("timeout",
  function()
    status = io.popen("ifconfig | grep tun0")
    if status:read() == nil then
        vpnwidget:set_markup(markup(red, ""))
    else
        vpnwidget:set_markup(markup(green, "  VPN"))
    end
    status:close()    
  end    
)    
vpnwidgettimer:start()

----------------------------------------------------------------------------------------
-- Uptime

uptimeicon = wibox.widget.imagebox(beautiful.widget_uptime)
vicious.cache(vicious.widgets.uptime)

uptimewidget = wibox.widget.textbox()
uptimewidget:set_align("right")
vicious.register(uptimewidget, vicious.widgets.uptime, markup(blue, "$1") .. markup (gray, "D ") .. markup(blue, "$2") .. markup(gray, "h ") .. markup(blue, "$3") .. markup(gray, "m"))

----------------------------------------------------------------------------------------
-- Conky HUD

function get_conky()
    local clients = client.get()
    local conky = nil
    local i = 1
    while clients[i]
    do
        if clients[i].class == "Conky"
        then
            conky = clients[i]
        end
        i = i + 1
    end
    return conky
end
function raise_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = true
    end
end
function lower_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = false
    end
end
function toggle_conky()
    local conky = get_conky()
    if conky
    then
        if conky.ontop
        then
            conky.ontop = false
        else
            conky.ontop = true
        end
    end
end

----------------------------------------------------------------------------------------
-- Test

mygraph = awful.widget.graph()
mygraph:set_width(50)
--mygraph:set_scale(true)
mygraph:set_max_value(100)
mygraph:set_background_color('#494B4F')
mygraph:set_color('#FF5656')
mygraph:set_color('#FF5656')

mygraph:add_value(50)

----------------------------------------------------------------------------------------
