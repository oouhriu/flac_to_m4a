<<'--'
    Author: Aaron Dickson
    Date:   13-OCT-23
    File:   music_main.sh
    Purpose: To call other Shell Scripts, acts as main
--


#!/bin/bash

FLAC=${CHILD_A:=/Users/Aaron/deemixMusic/FLAC} # Global Path Definition for FLAC folder
DEEMIX=${CHILD_E:=/Users/Aaron/deemixMusic}

mp3_count=$(ls "$FLAC"/*/*.mp3 2> /dev/null |wc -l | bc)  #Defines 'mp3_count' as the number of .mp3 files inside FLAC directory
flac_count=$(ls "$FLAC"/*/*.flac 2> /dev/null |wc -l | bc)  #Defines 'flac_count' as the number of .flac files inside FLAC directory

cd $DEEMIX


if [ "$mp3_count" == 0 ] && [ "$flac_count" != 0 ]; then   # If no .mp3 files and there are .flac files
    # echo "run scripts"
    sh m4a_convert.sh               # Execute all other shell scripts
    sh beautify_add.sh
    sh music_add.sh
else

        if [ "$mp3_count" == 0 ] && [ "$flac_count" == 0 ]; then
            osascript -e 'tell app "System Events" to display dialog "ERROR:    No .flac files detected." with title ".flac to .m4a" buttons "OK"'
        else            # If no .flac and no .mp3 detected, then display a dialog box

                if [ "$mp3_count" != 0 ] && [ "$flac_count" != 0 ]; then
                    osascript -e 'tell app "System Events" to display dialog "ERROR:    .mp3 and .flac files detected. Nothing deleted." with title ".flac to .m4a" buttons "OK"'
                else            # If .flac and .mp3 detected, then display a dialog box

                    osascript -e 'tell app "System Events" to display dialog "ERROR:    .mp3 files detected. Files deleted." with title ".flac to .m4a" buttons "OK"'
                    rm -r $FLAC/*   # Remove contents of FLAC directory
                fi
        fi
fi
