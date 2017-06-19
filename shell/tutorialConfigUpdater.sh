#!/usr/bin/env bash
#created by JACOBMENKE at Mon Jun 12 17:33:50 EDT 2017

tutorialDir="$HOME/Documents/tutorialsRepo"

printf "copying zshrc"
cp ~/.zshrc "$tutorialDir/zsh"
printf "copying vimrc"
cp ~/.vimrc "$tutorialDir/vim"

printf "copying tmux.conf"
cp ~/.tmux.conf "$tutorialDir/tmux"

printf "copying shell_aliases_functions"
cp ~/.shell_aliases_functions.sh "$tutorialDir/aliases"

printf "copying shellScripts"
cp ~/Documents/shellScripts/*.sh "$tutorialDir/shell"

printf "copying vis ncmpcpp mpd"
cp -R ~/.config/vis "$tutorialDir/ncmpcpp-mpd-vis"
printf "emptying mpd  log"
echo > "$tutorialDir/ncmpcpp-mpd-vis/.mpd/mpd.log"

echo > /Users/jacobmenke/Documents/tutorialsRepo/ncmpcpp-mpd-vis/.mpd/mpd.log
cp -R ~/.config/ncmpcpp "$tutorialDir/ncmpcpp-mpd-vis"
cp -R ~/.mpd "$tutorialDir/ncmpcpp-mpd-vis"

cp ~/Documents/iterm-jm-colors.itermcolors "$tutorialDir"
