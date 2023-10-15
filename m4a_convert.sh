<<'--'
Author: Aaron Dickson
Date:   13-OCT-23
File:   m4a_convert.sh
Purpose: Converts .flac to .m4a
--


#!/bin/bash

FLAC=${CHILD_A:=/Users/Aaron/deemixMusic/FLAC} # Global Path Definition for FLAC folder
M4A=${CHILD_B:=/Users/Aaron/deemixMusic/M4A} # Global Path Definition for M4A folder


cd $FLAC     # Current Directory /Users/Aaron/deemixMusic/FLAC
cp -a $FLAC/. $M4A   # Copy contents of FLAC directory into /Users/Aaron/deemixMusic/M4A
rm -r $FLAC/*   # Remove contents of FLAC directory
cd $M4A     # Current Directory /Users/Aaron/deemixMusic/M4A

for file in ./*/*.flac    # Loop for all .flac files in Current Directory
do  
    /usr/local/bin/ffmpeg -i "$file" -acodec alac -c:v -codec -vn "${file%.*}.m4a"
        # Converts .flac file to .m4a
done

sleep 2   # Pause for 2 seconds