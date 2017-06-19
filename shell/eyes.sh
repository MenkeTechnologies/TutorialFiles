#!/usr/bin/env bash

trap "tput cnorm; clear; ls -G -FlhAO; exit" INT
trap 'fortuneQuote=$(fortune)' 3 

declare -a ary

for file in $(cowsay -l); do
	ary+=( $file )	 	
done
rangePossibleIndices=${#ary[*]}

let rangePossibleIndices--

while true; do
	tput civis
	fortuneQuote="$(fortune)"
	fortuneQuote="$(figlet -f $1 \"$fortuneQuote\")"
	clear
	randIndex=$(jot -r 1 0 $rangePossibleIndices )
	view=${ary[$randIndex]}

	echo "$fortuneQuote" | cowsay -f $view -n | lolcat
	sleep 60 
done
