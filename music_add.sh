<<'--'
    Author: oouhriu
    Date:   13-OCT-23
    File:   music_add.sh
    Purpose: Adds .m4a files into Music Library
--


#!/bin/bash

M4A=${CHILD_B:=/Users/Aaron/deemixMusic/M4A} # Global Path Definition for M4A folder
MUSIC=${CHILD_D:=/Users/Aaron/Music/iTunes/iTunes\ Media/Automatically\ Add\ to\ Music.localized}   # Global Path Definition for Music folder


open -gja "Music"      # Open Music App in background
cp -a $M4A/. "$MUSIC"  # Move contents of M4A to MUSIC, which Automatically adds to music library

sleep 2  # 2 Seconds sleep

cd $M4A           # Current Directory /Users/Aaron/deemixMusic/M4A
rm -r $M4A/*      # Remove all from /Users/Aaron/deemixMusic/M4A
