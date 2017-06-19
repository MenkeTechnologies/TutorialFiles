#!/usr/bin/env bash

executableProgram=$1
path="#!/usr/bin/env $executableProgram"
shift

usage(){
#here doc for printing multiline
	cat <<\endofmessage
usage:
	script $1=executableProgram $*=files
endofmessage
	printf "\e[0m"
}

if [[ $# < 2 ]]; then
	usage
	exit
fi

addContents(){
	echo -e "\e[1;4m Adding shebang : $path to $file\e[0m"
	echo "$path" > "$file"
	echo "$tail" >> "$file"
	chmod u+x "$file"
}

for file; do
	lineCounter=1
	found=false
	while read line; do
		let lineCounter++
		
		if [[ $line =~ ^\#! ]]; then
			found=true
			break;	
		fi
	done < $file

	if [[ $found == true ]]; then
		tail=$(tail +$lineCounter "$file")
		addContents
	fi

	if [[ $found == false ]]; then
		tail=$(cat "$file")
		addContents
	fi

done
