# not needed with HHKB
setxkbmap -option

if [[ $1 == 'set_control' ]]; then
	setxkbmap -option ctrl:nocaps
	# xcape -e 'Control_L=Escape'
	setxkbmap -option altwin:swap_lalt_lwin
fi

xset r rate 250 40

