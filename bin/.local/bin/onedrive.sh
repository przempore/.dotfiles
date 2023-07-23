function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

function mount_OneDrive {
	run onedriver ~/OneDrive &
}

function umount_OneDrive {
	killall onedriver
	umount ~/OneDrive
}

if [ $1 == "mount" ]
then
	mount_OneDrive
fi

if [ $1 == "umount" ]
then
	umount_OneDrive
fi

