#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
#####   Author: JACOBMENKE
#####   Date: Sat Jul  8 20:57:59 EDT 2017
#####   Purpose: bash script to update software on the RPI itself
#####   Notes: 
#}}}***********************************************************

prettyPrint(){
	printf "\e[1;4m"
	printf "$1"
	printf "\n\e[0m"
}

prettyPrint "Updating Pathogen Plugins"
#update pathogen plugins
for pluginRepo in ~/.vim/bundle/*; do
	printf "%s: " "$(basename "$pluginRepo")"
	git -C "$pluginRepo" pull
done

prettyPrint "Updating OhMyZsh"
#upgrade_oh_my_zsh

prettyPrint "Updating OhMyZsh Plugins"

for zshPlugin in ~/.oh-my-zsh/custom/plugins/*; do
	printf "%s: " "$(basename "$zshPlugin")"
	git -C "$zshPlugin" pull
done

prettyPrint "Updating OhMyZsh Themes"

for zshPlugin in ~/.oh-my-zsh/custom/themes/*; do
	printf "%s: " "$(basename "$zshPlugin")"
	git -C "$zshPlugin" pull
done

