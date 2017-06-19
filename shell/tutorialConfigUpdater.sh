#!/usr/bin/env bash
#created by JACOBMENKE at Mon Jun 12 17:33:50 EDT 2017

tutorialDir="$HOME/Documents/tutorialsRepo"

boldPrinter(){
    printf "\e[1;4m$1\n\e[0m"
}

boldPrinter "Copying zshrc"
cp ~/.zshrc "$tutorialDir/zsh"
boldPrinter "Copying vimrc"
cp ~/.vimrc "$tutorialDir/vim"

boldPrinter "Copying tmux.conf"
cp ~/.tmux.conf "$tutorialDir/tmux"

boldPrinter "Copying shell_aliases_functions"
cp ~/.shell_aliases_functions.sh "$tutorialDir/aliases"

boldPrinter "Copying shellScripts"
cp $HOME/Documents/shellScripts/*.sh "$tutorialDir/shell"

boldPrinter "Copying vis ncmpcpp mpd"
cp -R ~/.config/vis "$tutorialDir/ncmpcpp-mpd-vis"
boldPrinter "Emptying mpd log"
echo > "$tutorialDir/ncmpcpp-mpd-vis/.mpd/mpd.log"

echo > "/Users/jacobmenke/Documents/tutorialsRepo/ncmpcpp-mpd-vis/.mpd/mpd.log"
cp -R ~/.config/ncmpcpp "$tutorialDir/ncmpcpp-mpd-vis"
cp -R ~/.mpd "$tutorialDir/ncmpcpp-mpd-vis"

boldPrinter "Copying iterm Colors"
cp "$HOME/Documents/iterm-jm-colors.itermcolors" "$tutorialDir"

boldPrinter "Copying vim plugins"

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
boldPrinter "Pushing ..."
git add .
git commit -m "update"
git push


