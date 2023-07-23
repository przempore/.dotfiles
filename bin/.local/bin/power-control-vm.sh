#!/usr/bin/env bash

start_or_stop_vm=0
if [ $# -eq 0 ]; then
	read -p "1. startvm
2. poweroff
	" start_or_stop_vm

	if ( "$start_or_stop_vm" != "1" ) || ( "$start_or_stop_vm" != "2" ); then
		echo start_or_stop_vm: $start_or_stop_vm
		exit 1
	fi
else
	echo "arguments: $1"
	if [[ "$1" == "startvm" ]]; then
		start_or_stop_vm=1
	elif [[ "$1" == "poweroff" ]]; then
		start_or_stop_vm=2
	fi
fi

selected=`vboxmanage list vms | awk '{print substr($2, 2, length($2)-2)}'`
vm_count=`vboxmanage list vms | wc -l`

if [[ ${vm_count} > 1 ]]; then
    selected=`vboxmanage list vms | fzf --preview "vboxmanage showvminfo {2}"`
    selected=`echo ${selected} | awk '{print substr($2, 2, length($2)-2)}'`
fi

if [[ $start_or_stop_vm == 1 ]]; then
    vboxmanage startvm --type headless ${selected}
else
    vboxmanage controlvm ${selected} poweroff
fi

