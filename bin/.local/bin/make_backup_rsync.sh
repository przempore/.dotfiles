#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

today=`date '+%H%M_%d%Y'`

echo "making backup with name 'thinkpad_backup_${today}'"
mkdir -p /run/media/porebski/72946F89946F4EA3/thinkpad_backup_${today}

rsync -aAXv /  \
  --exclude="/backup"  \
  --exclude="/proc/*"  \
  --exclude="/tmp/*"  \
  --exclude="/mnt/*"  \
  --exclude="/dev/*"  \
  --exclude="/sys/*"  \
  --exclude="/run/*"  \
  --exclude="/media/*"  \
  --exclude="/var/log"  \
  --exclude="/var/cache/apt/archives"  \
  --exclude="/usr/src/linux-headers*"  \
  --exclude="/home/porebski/.gvfs"  \
  --exclude="/home/porebski/.cache"  \
  --exclude="/home/porebski/.local/share/Trash"  \
  --exclude="/home/porebski/Projects/*"  \
  --exclude="/home/porebski/OneDrive"  \
  --exclude="/home/porebski/GoogleDrive"  \
  --exclude="/home/porebski/Videos"  \
  --exclude="/home/porebski/E_drive"  \
  --exclude="/home/porebski/VirtualBox\ VMs/*"  \
  --exclude="/home/porebski/Downloads/*"  \
  --exclude="/home/porebski/.rustup/*"  \
  --exclude="/home/porebski/.wine/*"  \
  --exclude="/home/porebski/.cargo/*"  \
  --exclude="/home/porebski/.conan/*"  \
  --exclude="/home/porebski/.vagrant.d/*"  \
  --exclude="/home/porebski/Games/*"  \
  --exclude="/run/media/porebski/"  \
  --exclude="/home/porebski/.shutter/" \
  --exclude="/timeshift" \
  /run/media/porebski/72946F89946F4EA3/thinkpad_backup_${today} \
  > /run/media/porebski/72946F89946F4EA3/thinkpad_backup_${today}/backup_rsync.log \
  2>/run/media/porebski/72946F89946F4EA3/thinkpad_backup_${today}/backup_rsync.err

echo "Process finished with error code: $?" >> /run/media/porebski/72946F89946F4EA3/thinkpad_backup_${today}/backup_rsync.log
