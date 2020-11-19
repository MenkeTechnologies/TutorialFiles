#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
##### Author: JACOBMENKE
##### Date: Mon Jul 10 19:28:12 EDT 2017
##### Purpose: bash script to sync two directories
##### Notes: first arg is origin 2nd arg is destination
#}}}***********************************************************
firstFile="$1"

if (($# < 2)); then
    echo "usage: sync.sh <file1> <file2>" >&2
    exit 1
fi

#add backslash if not already present to first file
#to make sure the contents of folder 1 are synced not the folder itself
if [[ "${firstFile: -1}" != "/" ]]; then
    firstFile="${firstFile}/"
fi

printf "\e[44;37mSyncing \"$firstFile\" to \"$2\"\n"
#sync first folder to second folder
rsync -avvhr --info=progress2 --stats "$firstFile" "$2"
printf "Done\n\e[0m"
