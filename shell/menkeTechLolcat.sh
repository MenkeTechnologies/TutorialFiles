#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
##### Author: JACOBMENKE
##### Date: Mon Jul 10 19:16:52 EDT 2017
##### Purpose: bash script to print out Menke Tech with figlet and rainbow color
##### Notes:
#}}}***********************************************************

tput civis

printf "\e[0m"
trap 'tput cnorm; exit' INT
while true; do
    clear
    figlet -f avatar "Menke
    Tech" | lolcat
    sleep 1000
done
