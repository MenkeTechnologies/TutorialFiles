#!/usr/bin/env bash
#created by JACOBMENKE at Mon Jun 12 17:33:50 EDT 2017

tutorialDir="$HOME/Documents/tutorialsRepo"

boldPrinter(){
    printf "\e[1m$1\n\e[0m"
}

boldPrinter "copying zshrcd"
cp ~/.zshrc "$tutorialDir/zsh"
boldPrinter "copying vimrc"
cp ~/.vimrc "$tutorialDir/vim"

boldPrinter "copying tmux.conf"
cp ~/.tmux.conf "$tutorialDir/tmux"

boldPrinter "copying shell_aliases_functions"
cp ~/.shell_aliases_functions.sh "$tutorialDir/aliases"

boldPrinter "copying shellScripts"
cp $HOME/Documents/shellScripts/*.sh "$tutorialDir/shell"

boldPrinter "copying vis ncmpcpp mpd"
cp -R ~/.config/vis "$tutorialDir/ncmpcpp-mpd-vis"
boldPrinter "emptying mpd log"
echo > "$tutorialDir/ncmpcpp-mpd-vis/.mpd/mpd.log"

echo > "/Users/jacobmenke/Documents/tutorialsRepo/ncmpcpp-mpd-vis/.mpd/mpd.log"
cp -R ~/.config/ncmpcpp "$tutorialDir/ncmpcpp-mpd-vis"
cp -R ~/.mpd "$tutorialDir/ncmpcpp-mpd-vis"

cp "$HOME/Documents/iterm-jm-colors.itermcolors" "$tutorialDir"

boldPrinter "copying vim plugins"

#cp -R "$HOME/.vim" "$tutorialDir/vim"

cd "$tutorialDir"


boldPrinter "Removing .git dirs....:)"

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


