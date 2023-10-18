# flac_to_m4a

Deemix Shell Script that is run after completion of downloading .flac files.
music_main.sh is executed, which checks the validity of the FLAC folder and files within.
If all checks come back clear, all other 3 scripts are run.

m4a_convert.sh converts the .flac files to .m4a.

beautify_add.sh adds cover art and music tags.

music_add.sh adds the tagged .m4a files to Music App.
