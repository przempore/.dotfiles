#!/bin/sh
echo "home configuration script"
xrandr --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output HDMI1 --off --output HDMI2 --primary --mode 3840x1600 --pos 1920x0 --rotate normal --output VIRTUAL1 --off
