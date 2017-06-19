#!/usr/bin/env bash
ADDRESS="jacobmenke@98.209.117.32:/var/services/web"

echo -e "\033[44m\033[37mUploading $* to $ADDRESS"
for i in "$@"; do
	scp -r -P 7777 "$i" "$ADDRESS"
done

echo -e "Done\033[0m"
