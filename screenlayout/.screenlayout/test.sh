#/bin/env bash
count=`xrandr | grep " connected " | awk '{ print$1 }' | wc -l`
echo "count: $count"
names=`xrandr | grep " connected " | awk '{ print$1 }'`
for name in $names; do
    if [[ $name == "None-1-1" ]]; then
        ((count = count-1))
    fi
done

echo "new count: $count"
