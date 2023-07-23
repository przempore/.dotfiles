#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Enter your username: "
read username

hostname=`uname -a | awk '{print $2}'`

today=`date '+%H%M_%d%Y'`

echo "making backup with name 'n53sv_backup_${today}'"
mkdir -p /run/media/$username/72946F89946F4EA3/${hostname}_backup_${today}

tar -cvpzf /run/media/$username/72946F89946F4EA3/${hostname}_backup_${today}/backup.tar.gz \
    --one-file-system \
    --absolute-names \
    --exclude=/backup \
    --exclude=/proc \
    --exclude=/tmp \
    --exclude=/mnt \
    --exclude=/dev \
    --exclude=/sys \
    --exclude=/run \
    --exclude=/media \
    --exclude=/var/log \
    --exclude=/var/cache/apt/archives  \
    --exclude=/usr/src/linux-headers*  \
    --exclude=/home/$username/.gvfs  \
    --exclude=/home/$username/.cache  \
    --exclude=/home/$username/.local/share/Trash  \
    --exclude=/home/$username/Projects/*  \
    --exclude=/home/$username/OneDrive  \
    --exclude=/home/$username/GoogleDrive  \
    --exclude=/home/$username/Videos  \
    --exclude=/home/$username/E_drive  \
    --exclude=/home/$username/VirtualBox\ VMs/*  \
    --exclude=/home/$username/Downloads/*  \
    --exclude=/home/$username/.rustup/*  \
    --exclude=/home/$username/.wine/*  \
    --exclude=/home/$username/.cargo/*  \
    --exclude=/home/$username/.conan/*  \
    --exclude=/home/$username/.vagrant.d/*  \
    --exclude=/home/$username/Games/*  \
    --exclude=/run/media/$username/  \
    --exclude=/home/$username/.shutter/ \
    --exclude=/timeshift \
        / > /run/media/$username/72946F89946F4EA3/${hostname}_backup_${today}/backup.log  \
        2>/run/media/$username/72946F89946F4EA3/${hostname}_backup_${today}/backup.err

echo "Process finished with error code: $?" >> /run/media/$username/72946F89946F4EA3/${hostname}_backup_${today}/backup.log

