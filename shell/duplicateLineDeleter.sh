#!/usr/bin/env bash
#: created by JAKOBMENKE --> Thu May 11 12:23:28 EDT 2017 

HOME_DIR=/Users/jacobmenke
SCRIPTS_DIR=$SCRIPTS
BACKUP_DIR=$SCRIPTS_DIR/rcBackups


usage(){
#here doc for printing multiline
	cat <<\endofmessage
usage:
	script $1=file
Endofmessage
	printf "\e[0m"
}

if [[ $# < 1 ]]; then
	usage >&2
	exit 1
fi

if [[ ! -d $BACKUP_DIR ]]; then
	mkdir $BACKUP_DIR
fi

for file; do
	cp "$file" "$BACKUP_DIR/$file"
	contents=$(cat -s "$file")
	echo "$contents" > "$file"
done

#sed -e 1d -e 3d -e 5d -e 10d
