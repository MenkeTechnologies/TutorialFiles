#!/usr/bin/env bash
echo -e "${BLUE}Uploading $*"
for i in "$@"; do
	scp -r -P 7778 "$i" pi@98.209.117.32:~/Desktop

done
echo -e "Done${RESET}"
