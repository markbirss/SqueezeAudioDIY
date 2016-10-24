#!/bin/bash
title=$(cat /usr/share/sadiy_files/setup/version)

#------------------------------------
#FUNCTIONS
#------------------------------------
install_lms () {
  service logitechmediaserver stop
  install=$(ls | grep logitechmediaserver_7.7.5_all.deb)
  dpkg -i /usr/share/sadiy_files/installers/lms_stable/$install
  rm /usr/share/sadiy_files/installers/lms_stable/index*
  sadiy_setup
}

download_lms () {
  wget http://downloads.slimdevices.com/LogitechMediaServer_v7.7.5/ > /dev/null 2>&1
  exitstatus=$?
  if [ $exitstatus = 0 ]
    then
      echo "[ OK ] INDEX RECEIVED"
    else
      echo "[ ERROR ] INDEX DOWNLOAD FAILED"
  fi
  download=$(grep logitechmediaserver_....._all.deb ./index.html | cut -c82-114)
  echo "DOWNLOADING LMS 7.7.5"
  wget http://downloads.slimdevices.com/LogitechMediaServer_v7.7.5/$download
  exitstatus=$?
  if [ $exitstatus = 0 ]
    then
      echo "[ OK ] LMS 7.7.5 DOWNLOADED"
    else
      echo "[ ERROR ] LMS 7.7.5 DOWNLOAD FAILED"
  fi
}

#------------------------------------
#INSTALL
#------------------------------------
cd /usr/share/sadiy_files/installers/lms_stable/
check=$(ls | grep logitechmediaserver_7.7.*_all.deb)
if [ check = logitechmediaserver_7.7.5_all.deb ]
  then
    install_lms
  else
    download_lms
    install_lms
fi