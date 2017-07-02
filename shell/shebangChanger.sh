#!/usr/bin/env bash
if (( $# < 2 )); then
	usage
	exit
fi


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


addContents(){
	printf "\e[1;4m Adding shebang : $path to $file\e[0m\n"
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

		if [[ $line =~ ^\# ]]; then
			found=false
			break;	
		fi

		if [[ $line =~ ^[a-zA-Z]+ ]]; then
			found=false
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
