#!/bin/env bash

function first_monitor_from_two_at_host {
    if [[ $HOSTNAME == "przemek-ThinkPad" ]]; then
        bspc monitor $1 -d 1 2 3
    else
        bspc monitor $1 -d 1 2 3 4 5
        for m in {6..10}; do
            bspc desktop -f $m
            bspc node -f @parent
            bspc node -d $((m - 5))
        done
    fi
}

function second_monitor_from_two_at_host {
    if [[ $HOSTNAME == "przemek-ThinkPad" ]]; then
        bspc monitor $1 -d 4 5 6 7 8 9 10
    else
        bspc monitor $1 -d 6 7 8 9 10
    fi
}

function two_monitor_setup {
    bspc_count=0
    for x in `xrandr --query | grep -w connected | awk '{print $1}'`;
    do
        if [[ $bspc_count -eq 0 ]]; then
            first_monitor_from_two_at_host $x
        else
            second_monitor_from_two_at_host $x
        fi
        bspc_count=$((bspc_count + 1))
    done
}

function three_monitor_setup {
    for x in `xrandr --query | grep -w connected | awk '{print $1}'`;
    do
        if [[ $bspc_count -eq 0 ]]; then
            bspc monitor $x -d 1 2 3
        elif [[ $bspc_count -eq 1 ]]; then
            bspc monitor $x -d 4 5 6 7
        else
            bspc monitor $x -d 8 9 0
        fi
        bspc_count=$((bspc_count + 1))
    done
}

function do_bspwm_monitors {
    if [ $1 -eq 1 ]; then
        bspc monitor $2 -d 1 2 3 4 5 6 7 8 9 10
    elif [ $1 -eq 2 ]; then
        two_monitor_setup
    elif [ $1 -eq 3 ]; then
        three_monitor_setup
    fi
}

# TODO: make it hostname dependent


connected=`xrandr --query | grep -w "connected" | awk '{print $1}'`
count=`xrandr | grep " connected " | awk '{ print$1 }' | wc -l`
echo "count: $count"

main_display="--output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal"
is_DP1_connected=0;
for c in $connected; do
    if [[ $c = "DP1" ]]; then
        is_DP1_connected=1;
    fi
done
if [[ $is_DP1_connected -eq 1 ]]; then
    echo "count=$count"
    count=$((count - 1));
    echo "count=$count"
fi

if [[ $count -eq 2 ]]; then
    main_display="--output eDP1 --mode 1920x1080 --pos 1920x0 --rotate normal"
elif [[ $count -eq 3 ]]; then
    main_display="--output eDP1 --mode 1920x1080 --pos 3840x0 --rotate normal"
fi

echo "main_display: $main_display"

outputs=""

# count=0

# "--output DP1 --mode 2560x1440 --pos 1920x0 --rotate normal" \
# "--output eDP1 --mode 1920x1080 --pos 3840x0 --rotate normal" \

for x in \
"--output LVDS1 --mode 1920x1080 --pos 0x520 --rotate normal" \
"--output HDMI1 --primary --mode 1920x1080 --rotate normal" \
"--output HDMI2 --primary --mode 1920x1080 --rotate normal" \
"${main_display}" \
"--output DP1-1-8 --primary --mode 1920x1200 --pos 1920x0 --rotate normal" \
"--output DP1-2 --mode 1920x1200 --pos 0x0 --rotate normal" \
"--output LVDS-1 --mode 1920x1080 --pos 0x409 --rotate normal" \
"--output HDMI-1 --primary --mode 3840x1600 --pos 1920x0 --rotate normal" \
"--output HDMI-0 --primary --mode 3840x1600 --pos 0x0 --rotate normal";
do
    for c in $connected; do
        combined="$c $x"
        if [[ $(echo $combined | awk '{print substr($1, 1, length($1)) == substr($3, 1, length($3))}') -eq 1 ]]; then
            commands="${commands} ${x}"
            # count=$((count + 1))
        fi
    done
done

for x in "--output VGA1 --off" \
         "--output DP1 --off" \
         "--output DP1-1-1 --off" \
         "--output DP1-3 --off" \
         "--output LVDS1 --off" \
         "--output HDMI1 --off" \
         "--output HDMI2 --off" \
         "--output eDP1 --off" \
         "--output DP1-1-8 --off" \
         "--output DP1-2 --off" \
         "--output LVDS-1 --off" \
         "--output HDMI-1 --off"
do
    for c in $connected; do
        if [[ $x != *"$c"* ]]; then
            commands="${commands} ${x}"
        fi
    done
done

commands="xrandr ${commands}"
if [[ $count -eq 3 ]]; then
    echo "running work 3 monitors config"
    exec $HOME/.screenlayout/work_three_monitors.sh &
elif [[ $count -eq 2 ]]; then
    echo "running home configuration"
    exec $HOME/.screenlayout/home_monitor.sh &
else
    echo $commands
    eval $commands
fi


echo "args: $*"
if [[ "$*" == "bspwm" ]]; then
    echo "running bspwm config"
    do_bspwm_monitors $count $connected
fi
