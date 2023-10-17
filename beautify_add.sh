<<'--'
Author: Aaron Dickson
Date:   13-OCT-23
File:   beautify_add.sh
Purpose: Adds cover.png and explicit tag to .m4a files
--


#!/bin/bash

FLAC=${CHILD_A:=/Users/Aaron/deemixMusic/FLAC} # Global Path Definition for FLAC folder
M4A=${CHILD_B:=/Users/Aaron/deemixMusic/M4A} # Global Path Definition for M4A folder

cd $M4A     # Current Directory /Users/Aaron/deemixMusic/M4A

for folder in * ;   # Loop for all directories in /deemixMusic/M4A
do
    cd "$M4A"/"$folder"         # Loop and make Current directory as /deemixMusic/M4A/"$folder"
    OIFS="$IFS"                 # Defining IFS below for-loop to look at new lines instead of white space
    IFS=$'\n'                   # So $file can take in "01 - Example Song.m4a", without would just take "01"
    for file in `find . -type f -name "*.m4a"` 
    do                          # For-loop that only loops through .m4a files in current directory
        if 
            [ -f "$file" ];     # If file is valid
        then
            /usr/local/bin/ffmpeg -i $file -i cover.png -map 0 -map 1 -c copy -disposition:v:0 attached_pic out.m4a # Create copy of .m4a file with cover.png added
            mv out.m4a $file            # Rename copy of .m4a file to same as original, replacing it
            if 
                /usr/local/bin/exiftool -if '$Itunesadvisory eq "1"'  "${file%.*}.flac" # If .flac file explicit
            then 
                /usr/local/bin/exiftool -overwrite_original -Rating="Explicit" "${file%.*}.m4a" # Edit .m4a tag to be explicit 
                # QuickTime ItemList Tag for Explicit
            fi
            
            DISCNUMBER=`/usr/local/bin/exiftool -DISCNUMBER -s3 "${file%.*}.flac"` 
            DISCTOTAL=`/usr/local/bin/exiftool -DISCTOTAL -s3 "${file%.*}.flac"` 
            DISCJOINED="${DISCNUMBER}/${DISCTOTAL}"
            # echo "$DISCJOINED"
            /usr/local/bin/exiftool -overwrite_original -DiskNumber="$DISCJOINED" "${file%.*}.m4a"

            TRACKNUMBER=`/usr/local/bin/exiftool -TRACKNUMBER -s3 "${file%.*}.flac"` 
            TRACKTOTAL=`/usr/local/bin/exiftool -TRACKTOTAL -s3 "${file%.*}.flac"` 
            TRACKJOINED="${TRACKNUMBER}/${TRACKTOTAL}"
            # echo "$TRACKJOINED"
            /usr/local/bin/exiftool -overwrite_original -TrackNumber="$TRACKJOINED" "${file%.*}.m4a"

            /usr/local/bin/exiftool -overwrite_original -AppleStoreAccount="Aaron Dickson" "${file%.*}.m4a"

            BPM=`/usr/local/bin/exiftool -BPM -s3 "${file%.*}.flac"` 
            # echo "$BPM"
            /usr/local/bin/exiftool -BeatsPerMinute="$BPM" "${file%.*}.m4a"
            
        fi
    done
    find . -name "*.flac" -type f -delete  # Deletes all .flac files in M4A folder
    find . -name "*.png" -type f -delete   # Deletes all .png files in M4A folder
done

AppleStoreAccount

