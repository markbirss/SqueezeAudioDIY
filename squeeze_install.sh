#!/bin/bash

#------------------------------------
#PERMISSIONS REQUIRED
#------------------------------------
permissions=$(whoami)
if [ $permissions = root ]
then
        echo "Running as root."
else
        echo "Run script as root."
        exit
fi

#------------------------------------
#STOP SQUEEZELITE
#------------------------------------
service squeezelite stop

#------------------------------------
#DIRECTORIES
#------------------------------------
rm -R /Squeezelite
mkdir /Squeezelite
mkdir /Squeezelite/tools
mkdir /Squeezelite/logs
echo "Directories created."

#------------------------------------
#SQUEEZE TOOLS
#------------------------------------
cp ./squeeze_audio.sh /Squeezelite/tools
chmod +x /Squeezelite/tools/squeeze_audio.sh
cp ./squeeze_name.sh /Squeezelite/tools
chmod +x /Squeezelite/tools/squeeze_name.sh
cp ./squeeze_update.sh /Squeezelite/tools
chmod +x /Squeezelite/tools/squeeze_update.sh

#------------------------------------
#SYMLINKS FOR SQUEEZE TOOLS
#------------------------------------
cd /usr/bin
ln -s /Squeezelite/tools/squeeze_audio.sh /squeeze_audio
ln -s /Squeezelite/tools/squeeze_name.sh /squeeze_name
ln -s /Squeezelite/tools/squeeze_update.sh /squeeze_update

#------------------------------------
#INSTALL REQUIRED LIBRARIES
#------------------------------------
apt-get install libasound2-dev libflac-dev libmad0-dev libvorbis-dev libfaad-dev libmpg123-dev liblircclient-dev libncurses5-dev build-essential > /Squeezelite/logs/library_log.txt
echo "Installed required libraries."

#------------------------------------
#GIT
#------------------------------------
apt-get install git > /Squeezelite/logs/git_log.txt
echo "Git is installed"

#------------------------------------
#INSTALL SQUEEZELITE
#------------------------------------
apt-get install squeezelite > /Squeezelite/logs/apt_squeeze_log.txt
if [ $? = 0 ]
then
        echo "Installed Squeezelite using package manager."
else
        echo "Package manager does not have Squeezelite"
        echo "-----------------------------------------"
        echo "     Squeezelite will not auto start     "
        echo "     and will not have config files.     "
        echo "-----------------------------------------"
fi

#------------------------------------
#STOP SQUEEZELITE
#------------------------------------
service squeezelite stop
echo "Stopped Squeezelite process."

#------------------------------------
#COMPILE LATEST SQUEEZELITE
#------------------------------------
echo "Compiling latest Squeezelite:"
cd /Squeezelite
git clone https://github.com/ralph-irving/squeezelite.git
cd /Squeezelite/squeezelite
OPTS="-DDSD -DRESAMPLER" make

#------------------------------------
#SYMLINKS FOR SQUEEZELITE
#------------------------------------
echo "Creating symbolic links."
cd /usr/bin
mv squeezelite ./squeezelite.bac
ln -s /Squeezelite/squeezelite/squeezelite squeezelite

#------------------------------------
#START SQUEEZELITE
#------------------------------------
service squeezelite start
echo "Started Squeezelite."
exit
