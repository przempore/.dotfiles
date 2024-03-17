#!/bin/bash


if [ $# -ne 1 ]; then
    echo "Usage: $0 [default|projector]"
    exit 1
fi

ARG=$1

if [ "$ARG" == "default" ]; then
    autorandr --load $ARG
    bspc monitor DP-2 -d 1 2 3 4 5 6 7 8 9 10
elif [ "$ARG" == "projector" ]; then
    autorandr --load $ARG
    bspc monitor HDMI-0 -d 1 2 3 4 5
    bspc monitor DP-2 -d 6 7 8 9 10
fi
