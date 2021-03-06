#!/bin/bash
title=$(cat /usr/share/sadiy_files/setup/version)

#------------------------------------
#MENU
#------------------------------------
menu=$(whiptail --title "$title" --menu "Squeezebox options menu:" 18 60 10 \
"1" "Permanent mount" \
"2" "Back" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]
then
	if [ $menu = 1 ]; then
		/usr/share/sadiy_files/setup/scripts/options_lms/lms_network_mount.sh
	elif [ $menu = 2 ]; then
		sadiy_setup
  fi
else
	exit
fi

#remember to code network mount utility
