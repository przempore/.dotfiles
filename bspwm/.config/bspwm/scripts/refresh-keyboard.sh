#!/bin/bash

POSITIONAL_ARGS=()

for i in "$@"; do
  case $i in
    --variant=*)
      VARIANT="${i#*=}"
      shift # past argument=value
      ;;
    --=*)
      SEARCHPATH="${i#*=}"
      shift # past argument=value
      ;;
    --set_CTRL)
      SET_CTRL=YES
      shift # past argument with no value
      ;;
    --*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

echo "Keyboard VARIANT  = ${VARIANT}"
echo "SET_CTRL         = ${SET_CTRL}"


# not needed with HHKB
pkill sxhkd;
setxkbmap -option
if [[ $VARIANT == 'qwerty' ]]; then
    echo "set qwerty"
    setxkbmap -layout pl
fi

if [[ $VARIANT == 'dvorak' ]]; then
    echo "set dvorak"
    setxkbmap -layout pl -variant real-prog-dvorak
fi
# xcape -e 'Control_L=Escape'
if [[ $SET_CTRL ]]; then
	setxkbmap -option ctrl:nocaps
	setxkbmap -option altwin:swap_lalt_lwin
fi

# xset r rate 250 40
xset r rate 200 25

sxhkd -m 1 -c ~/.config/bspwm/sxhkd/sxhkdrc &
