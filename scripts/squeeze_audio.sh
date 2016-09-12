#!/bin/bash

#------------------------------------
#STOP SQUEEZELITE
#------------------------------------
service squeezelite stop
echo "Stopped Squeezelite."

#------------------------------------
#AUDIO DEVICES AVAILABLE
#------------------------------------
squeezelite -l > ./available_list.txt

#------------------------------------
#CREATE AVAILABLE LIST
#------------------------------------
sed -i -e 's/^[ \t]*//' -e 's/[ \t]*$//' ./available_list.txt #REMOVES SPACES FROM FILE
sed -i '1 d' ./available_list.txt #REMOVES FIRST LINE FROM FILE
sed -i '$ d' ./available_list.txt #REMOVES LAST LINE FROM FILE

#------------------------------------
#CREATE DEVICE LIST
#------------------------------------
sed 's/-.*//' ./available_list.txt > ./devices.txt #REMOVE EVERYTHING AFTER '-' CHAR
sed -i -e 's/^[ \t]*//' -e 's/[ \t]*$//' ./devices.txt #REMOVES SPACES FROM FILE

#------------------------------------
#SELECT DEVICE
#------------------------------------
available_list=$(cat -n ./available_list.txt)
device=$(whiptail --title "Available Devices:" --inputbox "$available_list" 30 140 Number 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "You chose:" $device
else
    echo "[ ERROR ] CANCELED"
    exit
fi

#------------------------------------
#EDIT SQUEEZELITE CONFIG FILE
#------------------------------------
selected_device=$(sed -n "${device}p" ./devices.txt)
sed -i 9s/.*/SL_SOUNDCARD=cha$selected_device/ /etc/default/squeezelite
sed -i '9s/$/"/' /etc/default/squeezelite
sed -i '9s/cha/"/' /etc/default/squeezelite

#------------------------------------
#VIEW NEW SETTINGS
#------------------------------------
name_settings=$(cat /etc/default/squeezelite)
whiptail --title "Current Settings" --msgbox "$name_settings" 30 100

#------------------------------------
#START SQUEEZELITE
#------------------------------------
service squeezelite start
echo "Started Squeezelite."

#------------------------------------
#TEMP FILES CLEANUP
#------------------------------------
rm ./available_list.txt
rm ./devices.txt
exit
