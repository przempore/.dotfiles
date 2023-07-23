#!/usr/bin/env sh
device=$(libinput list-devices | grep -i 'HHKB-Hybrid_2 Keyboard' -A10 | grep 'Capabilities.*keyboard *$' -C 5 | grep "Kernel:" | sed 's_.*\(/dev/input/event[0-9]*\).*_\1_')
[ -z "$device" ] && echo "device not found" && exit 1
echo "device found: $device"
sed -i 's_- "/dev/input/event[0-9]*"_- "'"$device"'"_' ~/.config/mouseless/config.yaml
mouseless --config ~/.config/mouseless/config.yaml
