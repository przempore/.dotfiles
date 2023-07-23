#!/usr/bin/env bash

selected_vm=`vboxmanage list vms | awk '{print substr($2, 2, length($2)-2)}'`
vm_count=`vboxmanage list vms | wc -l`

if [[ ${vm_count} > 1 ]]; then
    selected_vm=`vboxmanage list vms | fzf --preview "vboxmanage showvminfo {2}"`
    selected_vm=`echo ${selected_vm} | awk '{print substr($2, 2, length($2)-2)}'`
fi

selected_nic=`ip a | grep "state UP" | awk '{print substr($2, 0, length($2)-1)}' | fzf`

vboxmanage modifyvm $selected_vm --nic1 bridged --bridgeadapter1 $selected_nic

