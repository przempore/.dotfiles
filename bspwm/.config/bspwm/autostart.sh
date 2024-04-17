#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

function get_location {
    location=$(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq -r '"\(.location.lat):\(.location.lng)"')
    if [ -z $location ]; then
        location="52.5196:13.4069"
        echo "[bspwm autostart] no internet connection, setting location to Berlin [${location}" | systemd-cat
    fi
    echo "[bspwm autostart] location for redshift: ${location}" | systemd-cat
}
hostname=`hostnamectl hostname`
essid=`iwconfig wlp0s20f3 | awk -F\" '{print $2}'`

# $HOME/.screenlayout/screensetup.sh bspwm &
autorandr --load default
bspc monitor DP-2 -d 1 2 3 4 5 6 7 8 9 10

$HOME/.config/polybar/launch.sh &
$HOME/.config/bspwm/scripts/refresh-keyboard.sh --variant=dvorak &

run sxhkd -m 1 -c ~/.config/bspwm/sxhkd/sxhkdrc &

get_location
run redshift -l $location &
run variety &
run nm-applet &
run pamac-tray &
run xfce4-power-manager &
run volumeicon &
run env QT_SCALE_FACTOR=1.01 keepassxc &
run xfce4-clipman &
run barrier &
run conky -c $HOME/.config/bspwm/system-overview &

run firefox-developer-edition &

run whatsapp-nativefier &
run signal-desktop &
run caprine &

xsetroot -cursor_name left_ptr &
numlockx on &
blueberry-tray &

if [[ $hostname == "Ilum" ]]; then 
  picom --config $HOME/.config/bspwm/picom_ilum.conf &
else 
  picom --config $HOME/.config/bspwm/picom.conf &
fi
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
