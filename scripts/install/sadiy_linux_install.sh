#!/bin/bash
title=$(cat /usr/share/sadiy_files/setup/version)

#------------------------------------
#FUNCTION
#------------------------------------
view_settings () {
	name_settings=$(cat /etc/default/squeezelite)
	eval `resize` && whiptail --title "Current Settings" --msgbox "$name_settings" $LINES $COLUMNS
}

audio_changer () {
  squeezelite -l > /usr/share/sadiy_files/tmp/available_list.txt
  sed -i -e 's/^[ \t]*//' -e 's/[ \t]*$//' /usr/share/sadiy_files/tmp/available_list.txt #REMOVES SPACES FROM FILE
  sed -i '1 d' /usr/share/sadiy_files/tmp/available_list.txt #REMOVES FIRST LINE FROM FILE
  sed -i '$ d' /usr/share/sadiy_files/tmp/available_list.txt #REMOVES LAST LINE FROM FILE
  sed 's/-.*//' /usr/share/sadiy_files/tmp/available_list.txt > /usr/share/sadiy_files/tmp/devices.txt #REMOVE EVERYTHING AFTER '-' CHAR
  sed -i -e 's/^[ \t]*//' -e 's/[ \t]*$//' /usr/share/sadiy_files/tmp/devices.txt #REMOVES SPACES FROM FILE
  available_list=$(cat -n /usr/share/sadiy_files/tmp/devices.txt)
  display_list=$(cat -n /usr/share/sadiy_files/tmp/available_list.txt)
  device=$(eval `resize` && whiptail --title "$title" --inputbox "$available_list" $LINES $COLUMNS 1 3>&1 1>&2 2>&3)
  if [ $? = 0 ]; then
    selected_device=$(sed -n "${device}p" /usr/share/sadiy_files/tmp/devices.txt)
    sed -i 9s/.*/SL_SOUNDCARD=cha$selected_device/ /etc/default/squeezelite
    sed -i '9s/$/"/' /etc/default/squeezelite
    sed -i '9s/cha/"/' /etc/default/squeezelite
  fi
  rm /usr/share/sadiy_files/tmp/available_list.txt
  rm /usr/share/sadiy_files/tmp/devices.txt
}

name_changer () {
  inputbox=$(whiptail --title "$title" --inputbox "Please enter new name:" 18 60 New_Name 3>&1 1>&2 2>&3)
  if [ $? = 0 ]; then
    sed -i '6s:.*:SL_NAME=cha'$inputbox':' /etc/default/squeezelite
  	sed -i '6s:$:":' /etc/default/squeezelite
  	sed -i '6s:cha:":' /etc/default/squeezelite
  fi
}

#------------------------------------
#DIRECTORIES
#------------------------------------
rm -R /var/log/squeezeaudiodiy > /dev/null 2>&1
rm -R /usr/share/sadiy_files > /dev/null 2>&1
rm -R /usr/share/sadiy_files > /dev/null 2>&1
#MAKING NEW DIRECTORIES
mkdir /usr/share/sadiy_files
#SETUP DIRECTORY
mkdir /usr/share/sadiy_files/setup
#LOG DIRECTORY
mkdir /var/log/squeezeaudiodiy
#INSTALLERS DIRECTORIES
mkdir /usr/share/sadiy_files/installers
mkdir /usr/share/sadiy_files/installers/squeeze_latest
mkdir /usr/share/sadiy_files/installers/squeeze_include
mkdir /usr/share/sadiy_files/installers/lms_stable
mkdir /usr/share/sadiy_files/installers/lms_nightly
#TEMPORY DIRECTORY
mkdir /usr/share/sadiy_files/tmp
#SETTINGS DIRECTORIES
mkdir /usr/share/sadiy_files/settings
mkdir /usr/share/sadiy_files/settings/backups
echo "[ OK ] DIRECTORIES CREATED"

#------------------------------------
#STOP SQUEEZELITE
#------------------------------------
service squeezelite stop > /dev/null 2>&1

#------------------------------------
#SQUEEZE TOOLS
#------------------------------------
cp -R ./* /usr/share/sadiy_files/setup
rm /usr/bin/squeeze_setup > /dev/null 2>&1
rm /usr/bin/sadiy_setup > /dev/null 2>&1
ln -s /usr/share/sadiy_files/setup/scripts/linux/sadiy_setup.sh /usr/bin/squeeze_setup
ln -s /usr/share/sadiy_files/setup/scripts/linux/sadiy_setup.sh /usr/bin/sadiy_setup
if [ $? = 0 ]
  then
    echo "[ OK ] SQUEEZELITE TOOLS INSTALLED"
  else
    echo "[ ERROR ] SQUEEZELITE TOOLS INSTALL FAILED"
fi

#------------------------------------
#INSTALL REQUIRED LIBRARIES
#------------------------------------
apt-get update
apt-get install -y git wget xterm unzip ffmpeg libsoxr-dev libasound2-dev libflac-dev libmad0-dev libvorbis-dev libfaad-dev libmpg123-dev liblircclient-dev libncurses5-dev build-essential

#------------------------------------
#INSTALL SQUEEZELITE
#------------------------------------
apt-get install -y squeezelite
if [ $? = 0 ]
then
        echo "[ OK ] INSTALLED SQUEEZELITE VIA PACKAGE MANAGER"
else
        echo "[ ERROR ] PACKAGE MANAGER DOES NOT HAVE SQUEEZELITE"
        echo "[ ERROR ] -----------------------------------------"
        echo "[ ERROR ]      SQUEEZELITE WILL NOT AUTO START     "
        echo "[ ERROR ]      AND WILL NOT HAVE CONFIG FILES      "
        echo "[ ERROR ] -----------------------------------------"
fi
service squeezelite stop
sed -i '19s:.*:SB_EXTRA_ARGS=cha-d all=debug -f /tmp/squeezelite.log:' /etc/default/squeezelite
sed -i '19s:$:":' /etc/default/squeezelite
sed -i '19s:cha:":' /etc/default/squeezelite

#------------------------------------
#COMPILE SQUEEZELITE
#------------------------------------
unzip ./files/squeezelite-v1.8.5-802-linux.zip -d /usr/share/sadiy_files/installers/squeeze_include/
cd /usr/share/sadiy_files/installers/squeeze_include/squeezelite-master/
OPTS="-DDSD -DRESAMPLE -DALSA" make
rm /usr/bin/squeezelite > /dev/null 2>&1
cp ./squeezelite /usr/bin/

#------------------------------------
#FIRST CONFIG RUN
#------------------------------------
name_changer
audio_changer
view_settings
service squeezelite start
sadiy_setup
