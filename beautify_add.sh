<<'--'
    Author: Aaron Dickson
    Date:   13-OCT-23
    File:   beautify_add.sh
    Purpose: Adds cover.png and tags to .m4a files
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
        
            # -- Album Art -- #
                # Create copy of .m4a file with cover.png added
                /usr/local/bin/ffmpeg -i $file -i cover.png -map 0 -map 1 -c copy -disposition:v:0 attached_pic out.m4a
                mv out.m4a $file        # Rename copy of .m4a file to same as original, replacing it
            
            # -- Album Artst Tag -- #
                ALBUMARTIST=`/usr/local/bin/exiftool -overwrite_original -all:ALBUMARTIST  -s3 "${file%.*}.flac"` # Read ALBUMARTIST from .flac 
                ALBUMARTIST_joined="${ALBUMARTIST//$'\n/, '}" 
                ALBUMARTIST_joined=$(echo "${ALBUMARTIST_joined}" | sed 's/\(.*\),/\1 \&/g' )

            # -- Composer Tag -- #
                COMPOSER_FLAC=`/usr/local/bin/exiftool -overwrite_original -all:COMPOSER  -s3 "${file%.*}.flac"` # Read COMPOSER from .flac 
                COMPOSER="${COMPOSER_FLAC//$'\n/, '}" 
                COMPOSER=$(echo "${COMPOSER}" | sed 's/\(.*\),/\1 \&/g' )

            # -- Genre Tag -- #
                GENRE_FLAC=`/usr/local/bin/exiftool -overwrite_original -all:GENRE  -s3 "${file%.*}.flac"` # Read GENRE from .flac 
                GENRE="${GENRE_FLAC//$'\n//'}" 

            # -- Rating Tag -- #
                RATING_VALUE=`/usr/local/bin/exiftool -overwrite_original -ITUNESADVISORY -s3 "${file%.*}.flac"` # Read ITUNESADVISORY from .flac 
                if [[ "$RATING_VALUE" -eq 1 ]];   
                    then RATING="Explicit"          # If .flac file ITUNESADVISORY = 1 then set .m4a Rating variable to 'Explicit'
                elif [[ "$RATING_VALUE" -eq 2 ]]; 
                    then RATING="Clean"             # If .flac file ITUNESADVISORY = 2 then set .m4a Rating variable to 'Clean'
                else RATING="none"
                fi

            # -- Disc Tag -- #
                DISCNUMBER=`/usr/local/bin/exiftool -overwrite_original -DISCNUMBER -s3 "${file%.*}.flac"`  # Read DISCNUMBER from .flac 
                DISCTOTAL=`/usr/local/bin/exiftool -overwrite_original -DISCTOTAL -s3 "${file%.*}.flac"`  # Read DISCTOTAL from .flac 
                DISCJOINED="${DISCNUMBER}/${DISCTOTAL}"       # Make DISCJOINED variable "x/x" format

            # -- Track Tag -- #
                TRACKNUMBER=`/usr/local/bin/exiftool -overwrite_original -TRACKNUMBER -s3 "${file%.*}.flac"`  # Read TRACKNUMBER from .flac 
                TRACKTOTAL=`/usr/local/bin/exiftool -overwrite_original -TRACKTOTAL -s3 "${file%.*}.flac"`  # Read TRACKTOTAL from .flac 
                TRACKJOINED="${TRACKNUMBER}/${TRACKTOTAL}"       # Make TRACKJOINED variable "x/x" format

            # -- BPM Tag -- #
                BPM=`/usr/local/bin/exiftool --overwrite_original -BPM -s3 "${file%.*}.flac"`  # Read BPM from .flac 

            # -- Copyright Tag -- #
                # Sometimes Copyright information does not have correct symbol.
                # Below if-then statement looks at both replacing "(C)" and "(c)" to "©"
                # It will ignore if Copyright already has "©".
                # If Copyright is empty, will pull "Year" and "Publisher" and concatinate a Copyright tag

                COPYRIGHT=`/usr/local/bin/exiftool --overwrite_original -COPYRIGHT -s3 "${file%.*}.flac"`  # Read BPM from .flac 
                PUBLISHER=`/usr/local/bin/exiftool --overwrite_original -PUBLISHER -s3 "${file%.*}.flac"`  # Read PUBLISHER from .flac 
                DATE=`/usr/local/bin/exiftool --overwrite_original -DATE -s3 "${file%.*}.flac"`  # Read DATE from .flac 
                SYMBOL="©"
                YEAR=${DATE:0:4}

                if [[ "$COPYRIGHT" == *"$SYMBOL"* ]];    # If first letter of COPYRIGHT from .flac not "©".
                then echo "already copyright symbol!"
                else
                    if [[ "$COPYRIGHT" == *"(C)"* ]]||[[ "$COPYRIGHT" == *"(c)"* ]];   # If first 3 letters of COPYRIGHT from .flac equal (C) or (c)
                    then COPYRIGHT=${COPYRIGHT:4}           # Remove 2 brackets, C and whitespace from COPYRIGHT variable
                        COPYRIGHT="© ${COPYRIGHT}"          # Add © to the start of what remains from COPYRIGHT variable
                    else
                        if [[ ! -z "$COPYRIGHT" ]];    # If first letter of COPYRIGHT from .flac is not empty
                        then COPYRIGHT="© ${COPYRIGHT}"     # Add © to the start of COPYRIGHT variable
                        else
                            if [[ ! -z "$PUBLISHER" ]]||[[ -z "$COPYRIGHT" ]];   # If PUBLISHER from .flac is not empty and COPYRIGHT from .flac is
                            then COPYRIGHT="© ${YEAR} ${PUBLISHER}"  # Define COPYRIGHT variable as   "© YEAR PUBLISHER"
                            else echo "not enough metadata!"
                            fi
                        fi
                    fi
                fi

                # Write all variables to .m4a file
                /usr/local/bin/exiftool -overwrite_original -AlbumArtist="$ALBUMARTIST_joined" -Composer="$COMPOSER" -Genre="$GENRE" -Rating="$RATING" -DiskNumber="$DISCJOINED" -TrackNumber="$TRACKJOINED" -AppleStoreAccount="Aaron Dickson" -BeatsPerMinute="$BPM" -Copyright="$COPYRIGHT" "${file%.*}.m4a"   
        fi
    done
    find . -name "*.flac" -type f -delete           # Deletes all .flac files in M4A folder
    find . -name "*.png" -type f -delete            # Deletes all .png files in M4A folder
    find . -name "*.jpg" -type f -delete            # Deletes all .jpg files in M4A folder
    find . -name "*.m4a_original" -type f -delete   # Deletes all .m4a_original files in M4A folder
done