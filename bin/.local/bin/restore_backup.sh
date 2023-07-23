#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

backup_dir_name=%1

tar -xvpzf /run/media/porebski/72946F89946F4EA3/${backup_dir_name}/backup.tar.gz -C / --numeric-owner

