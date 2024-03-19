#!/bin/bash


if [ $# -ne 1 ] || ([ "$1" != "default" ] && [ "$1" != "projector" ]); then
    echo "Usage: $0 {default|projector}"
    exit 1
fi

ARG=$1

bspc query -N -n .window | while read -r window_id; do bspc node "$window_id" -d ^1; done
autorandr --load $ARG
if [ "$ARG" == "default" ]; then
    bspc monitor DP-2 -d 1 2 3 4 5 6 7 8 9 10
elif [ "$ARG" == "projector" ]; then
    bspc monitor HDMI-0 -d 1 2 3 4 5
    bspc monitor DP-2 -d 6 7 8 9 10
fi
