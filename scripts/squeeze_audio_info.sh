#!/bin/bash

#------------------------------------
#STOP SQUEEZELITE
#------------------------------------
service squeezelite stop
echo "Stopped Squeezelite."

#------------------------------------
#AUDIO DEVICES AVAILABLE
#------------------------------------
squeezelite -l > /usr/share/squeeze_files/tmp/available_list.txt

#------------------------------------
#CREATE AVAILABLE LIST
#------------------------------------
sed -i -e 's/^[ \t]*//' -e 's/[ \t]*$//' /usr/share/squeeze_files/tmp/available_list.txt #REMOVES SPACES FROM FILE
sed -i '1 d' /usr/share/squeeze_files/tmp/available_list.txt #REMOVES FIRST LINE FROM FILE
sed -i '$ d' /usr/share/squeeze_files/tmp/available_list.txt #REMOVES LAST LINE FROM FILE
display_list=$(cat -n /usr/share/squeeze_files/tmp/available_list.txt)

#------------------------------------
#QUESTION
#------------------------------------
if (eval `resize` && whiptail \
        --title "SqueezeAudioDIY | Coenraad Human" \
        --yesno "Would you like to change your audio device?: \n\n$display_list" \
        $LINES $COLUMNS $(( $LINES - 12 )) \
        --scrolltext ) then
        /usr/share/squeeze_files/setup/scripts/squeeze_audio.sh
    else
        exit
    fi
