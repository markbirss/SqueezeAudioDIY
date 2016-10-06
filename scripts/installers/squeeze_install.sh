#!/bin/bash

#LOG FILE NAME
logname=$(date +"%Y%m%d.%H%M%S")

#------------------------------------
#DIRECTORIES
#------------------------------------
rm -R /usr/share/squeeze_files > /dev/null 2>&1
exitstatus=$?
if [ $exitstatus = 0 ]
then
  echo "[ OK ] OLD FILES REMOVED"
fi
#MAKING NEW DIRECTORIES
mkdir /usr/share/squeeze_files
#SETUP DIRECTORY
mkdir /usr/share/squeeze_files/setup
#LOG DIRECTORIES
mkdir /usr/share/squeeze_files/logs
mkdir /usr/share/squeeze_files/logs/squeeze_install
mkdir /usr/share/squeeze_files/logs/squeeze_re-install
mkdir /usr/share/squeeze_files/logs/squeeze_latest
mkdir /usr/share/squeeze_files/logs/lms_install
mkdir /usr/share/squeeze_files/logs/lms_latest
#INSTALLERS DIRECTORIES
mkdir /usr/share/squeeze_files/installers
mkdir /usr/share/squeeze_files/installers/squeeze_latest
mkdir /usr/share/squeeze_files/installers/squeeze_include
mkdir /usr/share/squeeze_files/installers/lms_stable
mkdir /usr/share/squeeze_files/installers/lms_nightly
#TEMPORY DIRECTORY
mkdir /usr/share/squeeze_files/tmp
#SETTINGS DIRECTORIES
mkdir /usr/share/squeeze_files/settings
mkdir /usr/share/squeeze_files/settings/backups
echo "[ OK ] DIRECTORIES CREATED"

#------------------------------------
#STOP SQUEEZELITE
#------------------------------------
service squeezelite stop &>> /usr/share/squeeze_files/logs/squeeze_install/$logname #LOG SYSTEM

#------------------------------------
#SQUEEZE TOOLS
#------------------------------------
cp -R ./* /usr/share/squeeze_files/setup
chmod +x /usr/share/squeeze_files/setup/scripts/squeeze_setup.sh
rm /usr/bin/squeeze_setup &>> /usr/share/squeeze_files/logs/squeeze_install/$logname #LOG SYSTEM
ln -s /usr/share/squeeze_files/setup/scripts/squeeze_setup.sh /usr/bin/squeeze_setup
exitstatus=$?
if [ $exitstatus = 0 ]
  then
    echo "[ OK ] SQUEEZELITE TOOLS INSTALLED"
  else
    echo "[ ERROR ] SQUEEZELITE TOOLS INSTALL FAILED"
fi

#------------------------------------
#INSTALL REQUIRED LIBRARIES
#------------------------------------
apt-get update
apt-get install -y xterm unzip ffmpeg libsoxr-dev libasound2-dev libflac-dev libmad0-dev libvorbis-dev libfaad-dev libmpg123-dev liblircclient-dev libncurses5-dev build-essential &>> /usr/share/squeeze_files/logs/squeeze_install/$logname #LOG SYSTEM
exitstatus=$?
if [ $exitstatus = 0 ]
then
  echo "[ OK ] INSTALLED REQUIRED LIBRARIES"
else
  echo "[ ERROR ] LIBRARIES INSTALL FAILED"
fi

#------------------------------------
#INSTALL SQUEEZELITE
#------------------------------------
apt-get install -y squeezelite &>> /usr/share/squeeze_files/logs/squeeze_install/$logname #LOG SYSTEM
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

#------------------------------------
#STOP SQUEEZELITE
#------------------------------------
service squeezelite stop &>> /usr/share/squeeze_files/logs/squeeze_install/$logname #LOG SYSTEM

#------------------------------------
#COMPILE SQUEEZELITE
#------------------------------------
unzip ./files/squeezelite-v1.8.5-802.zip -d /usr/share/squeeze_files/installers/squeeze_include/
cd /usr/share/squeeze_files/installers/squeeze_include/squeezelite-master/
OPTS="-DDSD -DRESAMPLE -DALSA" make
rm /usr/bin/squeezelite &>> /usr/share/squeeze_files/logs/squeeze_install/$logname #LOG SYSTEM
cp ./squeezelite /usr/bin/

#------------------------------------
#START SQUEEZELITE
#------------------------------------
service squeezelite start
exit
