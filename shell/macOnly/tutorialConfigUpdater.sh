#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
##### Author: JACOBMENKE
##### Date: Mon Jul 10 11:59:28 EDT 2017
##### Purpose:  script to update multiple Github repos
##### Notes:TutorialFiles, PersonalWebsite, zpwr
#}}}***********************************************************
if [[ -n "$ZPWR" && -n "$ZPWR_LIB_INIT" ]]; then
    if ! source "$ZPWR_LIB_INIT" ""; then
        echo "Could not source dir '$ZPWR_LIB_INIT'."
        exit 1
    fi
else
    source="${BASH_SOURCE[0]}"
    while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
    dir="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
    source="$(readlink "$source")"
    [[ $source != /* ]] && source="$dir/$source" # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    dir="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"

    while [[ ! -f "$dir/.zpwr_root" ]]; do
        dir="$(dirname "$dir")"
        if [[ "$dir" == / ]]; then
            echo "Could not find .zpwr_root file up the directory tree." >&2
            exit 1
        fi
    done
    if ! source "$dir/scripts/init.sh" "$dir"; then
        echo "Could not source dir '$dir/scripts/init.sh'."
        exit 1
    fi
fi

tutorialDir="$HOME/Documents/tutorialsRepo"
websiteDir="$HOME/WebstormProjects/PersonalWebsite"
ZPWR_DIR="$ZPWR"
ZPWR_DIR_INSTALL="$ZPWR/install"
ZPWR_DIR_INSTALL_GTAGS="$ZPWR/install/g-tags"

shopt -s dotglob

[[ -n "$1" ]] && commitMessage="$1" || commitMessage="update"

#{{{ MARK:installer
#**************************************************************
cd "$ZPWR_DIR" || exit 1
git checkout dev

zpwrLog "Copying scripts to custom Installer Repo $ZPWR_DIR"
cp "$HOME/.gitignore_global" "$ZPWR_DIR_INSTALL"

type=ctags

if zpwrExists gtags; then
    zpwrLog "Regen GNU gtags to $HOME/GTAGS with $type parser"
    (
    builtin cd "$HOME"
    command rm GPATH GRTAGS GTAGS 2>/dev/null
    for file in \
        "$ZPWR/"* \
        "$ZPWR_ENV/"* \
        "$ZPWR_INSTALL/"* \
        "$ZPWR_AUTOLOAD_LINUX/"* "$ZPWR_AUTOLOAD_DARWIN/"* \
        "$ZPWR_AUTOLOAD_SYSTEMCTL/"* "$ZPWR_AUTOLOAD_COMMON/"* \
        "$ZPWR_COMPS/"* \
        "$ZPWR_SCRIPTS"/* \
        "$ZPWR_SCRIPTS_MAC/"*; do
        if [[ -f "$file" ]]; then
            echo "$file"
        fi
    done | gtags --accept-dotfiles --gtagslabel=$type -f -

    zpwrLog "gtags size: $(global -x ".*" | wc -l)"

    )
else
    zpwrLogConsoleErr "gtags does not exist"
fi

zpwrLog "Copying gtag => $HOME/"{GTAGS,GPATH,GRTAGS}
echo cp "$HOME/"{GTAGS,GPATH,GRTAGS} \
    "$tutorialDir"
cp "$HOME/"{GTAGS,GPATH,GRTAGS} \
    "$ZPWR_DIR_INSTALL_GTAGS"

zpwrLog "Updating vim plugins list"
bash "$ZPWR_SCRIPTS/gitRemoteRepoInformation.sh" "$HOME/.vim/bundle/"* >"$ZPWR_DIR_INSTALL/.vimbundle"
perl -0 -i -pe 's@\n.*wakatime.*\n@\n@g' "$ZPWR_INSTALL/.vimbundle"
zpwrLog "Updating zsh plugins list"
printf "" > "$ZPWR_DIR_INSTALL/.zshplugins"

if [[ -z $ZSH_CUSTOM ]]; then
    zpwrLogConsoleErr "ZSH_CUSTOM is null so can not update zsh plugins list"
else
    for dir in "$ZSH_CUSTOM/plugins/"*; do
        if basename "$dir" | grep -sq "example";then
            zpwrLog "not adding zsh plugin $dir"
            continue;
        else
            zpwrLog "adding zsh plugin $dir"
        fi

        bash "$ZPWR_SCRIPTS/gitRemoteRepoInformation.sh" "$dir" >>"$ZPWR_DIR_INSTALL/.zshplugins"
    done
fi


git add .
git commit -m "$commitMessage"
zpwrLog "Status"
git status
zpwrLog "Pushing..."
git push origin dev
#}}}***********************************************************

#{{{ MARK:tutorialDir
#**************************************************************
zpwrLog "Copying zshrc"
cp "$ZPWR_DIR_INSTALL/.zshrc" "$tutorialDir/zsh"
zpwrLog "Copying vimrc"
cp "$ZPWR_DIR_INSTALL/.vimrc" "$tutorialDir/vim"
zpwrLog "Copying minimal minvimrc"
cp "$ZPWR_ENV/.minvimrc" "$tutorialDir/vim"

zpwrLog "Copying gtag => $HOME/"{GTAGS,GPATH,GRTAGS}
echo cp "$HOME/"{GTAGS,GPATH,GRTAGS} \
    "$tutorialDir"
cp "$HOME/"{GTAGS,GPATH,GRTAGS} \
    "$tutorialDir"

zpwrLog "Copying tmux.conf"
rm -rf "$tutorialDir/tmux/"*
cp "$ZPWR_DIR_INSTALL/.tmux.conf" "$tutorialDir/tmux"
cp -R "$ZPWR_TMUX/"* "$tutorialDir/tmux/.tmux" 2>/dev/null

zpwrLog "Copying shell_aliases_functions $ZPWR_ALIAS_FILE to $tutorialDir"
cp "$ZPWR_ALIAS_FILE" "$tutorialDir/aliases"

zpwrLog "Copying shell scripts"
#clear out old scripts, dbl quotes escape asterisk
rm -rf "$tutorialDir/shell/"*
cp "$ZPWR_SCRIPTS"/*.{sh,zsh,pl,py} "$tutorialDir/shell"
cp -R "$ZPWR_SCRIPTS/macOnly" "$tutorialDir/shell"
cp -R "$HOME/.vim/UltiSnips" "$tutorialDir"
#README="$tutorialDir/shell/README.md"
#echo "# Mac and Linux Scripts" > "$README"
#bash "$ZPWR_SCRIPTS/headerSummarizer.sh" "$ZPWR_SCRIPTS/"*.sh >> "$README"
#echo "# Mac Only Scripts" >> "$README"
#bash "$ZPWR_SCRIPTS/headerSummarizer.sh" "$ZPWR_SCRIPTS/"macOnly/*.sh >> "$README"

#zpwrLog "Copying tags file"
#cp "$ZPWR_SCRIPTS/tags" "$tutorialDir/shell"

#zpwrLog "Copying $HOME/.ctags"
#cp "$HOME/.ctags" "$tutorialDir/ctags"

zpwrLog "Copying vis ncmpcpp mpd"
cp -R "$HOME/.config/vis" "$tutorialDir/ncmpcpp-mpd-vis"

zpwrLog "Emptying mpd log"
echo >"$tutorialDir/ncmpcpp-mpd-vis/.mpd/mpd.log"

echo >"$HOME/Documents/tutorialsRepo/ncmpcpp-mpd-vis/.mpd/mpd.log"
cp -R "$HOME/.config/ncmpcpp" "$tutorialDir/ncmpcpp-mpd-vis"
cp -R "$HOME/.mpd" "$tutorialDir/ncmpcpp-mpd-vis"

zpwrLog "Copying powerlevel config"
cp "$ZPWR_PROMPT_FILE" "$tutorialDir"

#zpwrLog "Copying vim plugins"

#sudo cp -R "$HOME/.vim" "$tutorialDir/vim"

cd "$tutorialDir" || exit 1

#zpwrLog "Removing .git dirs..."

#while read -r file; do
#if [[ -d "$file" ]]; then
#if [[ "$file" = .*\.git.* ]]; then
#sudo rm -rf "$file"
#else
#:
#fi
#fi
#done < <(find ./vim)

bash "$ZPWR_SCRIPTS/gitRemoteRepoInformation.sh" "$HOME/.vim/bundle/"* >"$tutorialDir/vim/.vimbundle"

zpwrLog "Updating Tutorial Files Repo"
git add .
git commit -m "$commitMessage"
zpwrLog "Status..."
git status
zpwrLog "Pushing..."
git push

#}}}***********************************************************

#{{{ MARK:websiteDir
#**************************************************************

dotdir="$websiteDir/downloads/dotfiles"

[[ ! -d "$dotdir" ]] && mkdir -p "$dotdir"

zpwrLog "Copying config files to websiteDir"
cp "$ZPWR_DIR_INSTALL/.vimrc" "$dotdir/.."
cp "$ZPWR_DIR_INSTALL/.tmux.conf" "$dotdir/.."
cp "$ZPWR_ALIAS_FILE" "$dotdir/.."
cp "$ZPWR_DIR_INSTALL/.zshrc" "$dotdir/.."

cp "$ZPWR_DIR_INSTALL/.vimrc" "$dotdir"
cp "$ZPWR_DIR_INSTALL/.tmux.conf" "$dotdir"
cp "$ZPWR_ALIAS_FILE" "$dotdir"
cp "$ZPWR_DIR_INSTALL/.zshrc" "$dotdir"

zpwrLog "Copying scripts to $websiteDir"
rm -rf "$websiteDir/downloads/scripts/"*
if [[ ! -d "$websiteDir"/downloads/scripts ]]; then
    mkdir -p "$websiteDir/downloads/scripts"
fi

cp "$ZPWR_SCRIPTS"/*.{sh,zsh,pl,py} "$websiteDir/downloads/scripts" 2>/dev/null
cp -R "$ZPWR_SCRIPTS/macOnly" "$websiteDir/downloads/scripts"

cd "$websiteDir/downloads" || exit 1
tar cfz MenkeTechnologiesShellScripts.tgz scripts
tar cfz dotfiles.tgz dotfiles
cd ..

git add .
git commit -m "$commitMessage"
zpwrLog "Status..."
git status
zpwrLog "Pushing..."
git push
#}}}***********************************************************
