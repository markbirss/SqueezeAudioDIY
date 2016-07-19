#!/bin/bash

#------------------------------------
#PERMISSIONS REQUIRED
#------------------------------------
permissions=$(whoami)

if [ $permissions = root ]
then
        echo Running as root.
else
        echo Run script as root.
        exit
fi

#------------------------------------
#INSTALL REQUIRED LIBRARIES
#------------------------------------
sudo apt-get install libasound2-dev libflac-dev libmad0-dev libvorbis-dev libfaad-dev libmpg123-dev liblircclient-dev libncurses5-dev build-essential

#------------------------------------
#GIT
#------------------------------------
sudo apt-get install git

#------------------------------------
#INSTALL SQUEEZELITE
#------------------------------------
sudo apt-get install squeezelite

#------------------------------------
#STOP SQUEEZELITE
#------------------------------------
sudo service squeezelite stop

#------------------------------------
#COMPILE LATEST SQUEEZELITE
#------------------------------------
cd
mkdir /home/$permissions/Squeezelite
cd /home/$permissions/Squeezelite
git clone https://github.com/ralph-irving/squeezelite.git
cd ./squeezelite
sudo OPTS="-DDSD -DRESAMPLER" make

#------------------------------------
#SYMLINKS FOR SQUEEZELITE
#------------------------------------
directory=$(pwd)
cd /usr/bin
sudo mv squeezelite ./squeezelite.bac
sudo ln -s $directory/squeezelite squeezelite

#------------------------------------
#START SQUEEZELITE
#------------------------------------
sudo service squeezelite start

echo Finished.
exit
