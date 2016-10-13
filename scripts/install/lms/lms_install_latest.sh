#!/bin/bash
title=$(cat /usr/share/sadiy_files/setup/version)

#------------------------------------
#INSTALL
#------------------------------------
cd /usr/share/sadiy_files/installers/lms_nightly/
wget http://downloads.slimdevices.com/nightly/?ver=7.9
download=$(grep logitechmediaserver_7.9.0~.........._all.deb ./index.html?ver=7.9 | cut -c27-85)
wget http://downloads.slimdevices.com/nightly/$download
service logitechmediaserver stop
install=$(ls | grep logitechmediaserver_7.9.0~.........._all.deb)
dpkg -i /usr/share/sadiy_files/installers/lms_nightly/$install
rm /usr/share/sadiy_files/installers/lms_nightly/index*
sadiy_setup
