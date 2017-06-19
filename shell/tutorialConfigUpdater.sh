#!/usr/bin/env bash
#created by JACOBMENKE at Mon Jun 12 17:33:50 EDT 2017

tutorialDir="$HOME/Documents/tutorialsRepo"

prettyPrint(){
    printf "\e[1m$1\n\e[0m"
}

prettyPrint "copying zshrcd"
cp ~/.zshrc "$tutorialDir/zsh"
prettyPrint "copying vimrc"
cp ~/.vimrc "$tutorialDir/vim"

prettyPrint "copying tmux.conf"
cp ~/.tmux.conf "$tutorialDir/tmux"

prettyPrint "copying shell_aliases_functions"
cp ~/.shell_aliases_functions.sh "$tutorialDir/aliases"

prettyPrint "copying shellScripts"
cp $HOME/Documents/shellScripts/*.sh "$tutorialDir/shell"

prettyPrint "copying vis ncmpcpp mpd"
cp -R ~/.config/vis "$tutorialDir/ncmpcpp-mpd-vis"
prettyPrint "emptying mpd log"
echo > "$tutorialDir/ncmpcpp-mpd-vis/.mpd/mpd.log"

echo > "/Users/jacobmenke/Documents/tutorialsRepo/ncmpcpp-mpd-vis/.mpd/mpd.log"
cp -R ~/.config/ncmpcpp "$tutorialDir/ncmpcpp-mpd-vis"
cp -R ~/.mpd "$tutorialDir/ncmpcpp-mpd-vis"

cp "$HOME/Documents/iterm-jm-colors.itermcolors" "$tutorialDir"

prettyPrint "copying vim plugins"

#cp -R "$HOME/.vim" "$tutorialDir/vim"

cd "$tutorialDir"


prettyPrint "Removing .git dirs....:)"

while read file; do
    if [[ -d "$file" ]]; then
        if [[ "$file" =~ .*git.* ]]; then
            rm -rf "$file"
        else
            :
        fi
    fi
done < <(find ./vim)

git status
git add .
git commit -m "update"
git push


