#!/usr/bin/env bash
echo -e "\e[44;37mUploading $*"
#loop through all arguments and upload with scp recursively to synology server
for i in "$@"; do
	scp -r -P 7777 "$i" jacobmenke@98.209.117.32:/var/services/homes/JAKENAS/holdingZone
done

echo -e "Done\e[0m"
