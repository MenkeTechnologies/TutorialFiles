#echo .bashrc
#cat ~/bannerString.txt
#sleep 0.2
if [[ -f /etc/bashrc  ]]; then
    . /etc/bashrc
fi
if [[ $- == *i* ]];then
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi
fi
#**********************************************************************
#                           MARK:ENVIRONMENT VARIABLES
#**********************************************************************
export CLICOLOR="YES"
export LSCOLORS="ExFxBxDxCxegedabagacad"
export TERM="xterm-256color"
export SCRIPTS="/Users/jacobmenke/Documents/shellScripts"
export PYSCRIPTS="/Users/jacobmenke/PycharmProjects"
export WCC="/Volumes/JAKESD/wcc/cps"
# Setting PATH for Python 3.5
# The orginal version is saved in .profile.pysave
export PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:/Users/jacobmenke/Documents/shellScripts:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
export HOMEBREW_GITHUB_API_TOKEN=519b78d13c6b655a45b3c2b97286938211cb9698
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home"
export IP="http://98.209.117.32"
export HISTSIZE=50000
export PS1=$'\[\E[1m\]\u@\h\[\E[35;0m\E[1;35m\] \d \T\[\E[0m\]\u2630\u2666\u2630\u2666\[\E[1;35m\]:\[\E[34m\]\w \[\E[0m\]\n\!\[\E[1;35m\]\u2630\u2666\[\E[0m\] '
export PS2=$'\[\E[37;44m\]\u2630\u2666\u2630\u2666-JAKOB-\u2630\u2666\u2630\u2630___\[\E[0m\]'
export PS4=$'\u2630\[\E[44;1;35m\]\u2630\u2666\u2630\u2666-JAKOB-\u2630\u2666\u2630\u2666\[\E[0m\]'
export HISTTIMEFORMAT=' %F %T _ '
export BLUE="\E[37;44m"
export RESET="\E[0m"
export GITHUB_ACCOUNT='MenkeTechnologies'
#**********************************************************************
#                           MARK:FUNCTION
#**********************************************************************
scnew(){
	suc
	cd $SCRIPTS
	bash '/Users/jacobmenke/Documents/shellScripts/createScriptButDontOpenSublime.sh' "$1"
}
suc(){
	subl $SCRIPTS
}
db(){
	#open -a Firefox $IP:8080/db
	( python3 $PYSCRIPTS/logIntoMyDB.py & )
}
clearList () {
	clear
	ls -FlhA
}
animate(){
	bash $SCRIPTS/animation.sh
}

blocksToSize(){
	read input
	local bytes=$(( input * 512 ))
	echo $bytes | humanReadable 
}

humanReadable(){
awk 'function human(x) {
         s=" B   KiB MiB GiB TiB EiB PiB YiB ZiB"
         while (x>=1024 && length(s)>1)
               {x/=1024; s=substr(s,5)}
         s=substr(s,1,4)
         xf=(s==" B  ")?"%5d   ":"%8.2f"
         return sprintf("Your size:"xf"%s", x, s)
      }
      {gsub(/^[0-9]+/, human($1));print}'
}

#**********************************************************************
#                           MARK:ALIASES
#**********************************************************************
#portable aliases
alias ll="clearList"
alias la="clearList"
alias l="ls -AFlh"
alias r="cd ..;clearList"
alias t="cd /;clearList"
alias d="cd ~/Desktop; clear; ls -FlhA"
alias vrc="vi ~/.vimrc"
alias p="vi +1000 ~/.bashrc; source ~/.bashrc; bash $SCRIPTS/backupBashConfig.sh 2> /dev/null"
alias deleteTab="sed -e '/^[ tab]*$/d'"
shopt -s cdspell
shopt -s expand_aliases
set -o vi
shopt -s globstar
alias b="bash"
alias upper='tr '\''a-z'\'' '\''A-Z'\'''
#over alias es
alias grep="grep --color=auto"
alias egrep="egrep --color=always"
alias tree='tree -afC'
#Darwin specific aliases
alias spd="du -csh {.[^.]*,..?*} * 2> /dev/null | gsort -h"
alias cpu="top -o cpu"
alias tip="top -o +command"
alias nd="defaults write com.apple.dock autohide-delay -float 100 && defaults write com.apple.dock tilesize -int 1 && killall Dock"
alias coolformater="sed -e 's/[^[:blank:]]/_&_/g' -e 's/[[:blank:]]/\/\/\/\/\//g'"
alias pkill="pkill -iIl"
#**********************************************************************
#                           MARK:PYTHON SCRIPTS
#**********************************************************************
alias b="python3 $PYSCRIPTS/blackBoard.py"
alias m="python $PYSCRIPTS/mapIt.py"
alias a="python $PYSCRIPTS/amazonSearch.py"
alias g="python $PYSCRIPTS/googleSearch.py"
alias shut="python3 $PYSCRIPTS/shutdown.py"
alias enter="python3 $PYSCRIPTS/enter.py"
alias ct="bash $SCRIPTS/createTextFile.sh"
alias pb="python3 $PYSCRIPTS/bills.py"
alias u="python3 $PYSCRIPTS/udemy.py"
alias f="source $SCRIPTS/goForward.sh"
alias i="ipconfig getifaddr en0"
#**********************************************************************
#                           MARK:SHELL SCRIPTS
#**********************************************************************
alias u="bash $SCRIPTS/upLoadPi.sh"
alias piweb="bash $SCRIPTS/uploadWebPi.sh"
alias ud="bash $SCRIPTS/upLoadDS.sh"
alias uweb="bash $SCRIPTS/uploadWebDS.sh"
alias s="bash $SCRIPTS/sync.sh"
alias sf="bash $SCRIPTS/directoryContentsSize.sh"
alias sc="cd $SCRIPTS; clearList"
alias blue="source $SCRIPTS/blueText.sh"
alias n="open /Volumes/homes/JAKENAS/softwareTutorials; exit"
alias dl="cd /Users/jacobmenke/Downloads; clearList; open ."
alias c="cd /Volumes/JAKESD/wcc/cps; clearList"
alias o="open ."
alias jobs="jobs -l"
#alias who="who -uHTba | sed '$ d'"
alias ts="cd /Users/jacobmenke/.Trash; clearList"
alias back="nohup /System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background > /dev/null &"
alias 8="( bash updater.sh > /Users/jacobmenke/updaterlog.txt 2>&1 &)"
alias sd="clear;ssh d "
alias sftpd="sftp d:/homes/JAKENAS/music"
alias sr="clear;ssh r"
alias emu="open /Volumes/JAKESD/EMU"
alias sdroot="clear;ssh -p 7777 root@98.209.117.32"
alias gc="$SCRIPTS/gitgo.sh"
alias watchGit="bash $SCRIPTS/watchServiceFSWatchGit.sh"
alias watchPiWeb="bash $SCRIPTS/watchServiceFSWatchPiWeb.sh"
#**********************************************************************
#                           MARK:REMOTE SHELLS SCRIPTS
#**********************************************************************
alias glt="ssh d -t 'sh /var/services/homes/JAKENAS/scripts/downloadTitlesLocal.sh'"
alias grt="ssh d -tt 'sh /var/services/homes/JAKENAS/scripts/downloadTitlesRemote.sh'"
alias v="open -a 'vnc viewer';enter & bash $SCRIPTS/sshTunnelVnc.sh"
alias rr="/Users/jacobmenke/Documents/shellScripts/rsyncr.sh"

alias mntpi="sshfs -o IdentityFile=/Users/jacobmenke/.ssh/id_rsa r:/var/www/html /Users/jacobmenke/Desktop/tuts/piweb/"
alias mntds="sshfs -o IdentityFile=/Users/jacobmenke/.ssh/id_rsa d:/volume1/homes/JAKENAS/softwareTutorials /Users/jacobmenke/Desktop/tuts/ds/"
#**********************************************************************
#                           MARK:NVM                            
#**********************************************************************
. $(brew --prefix nvm)/nvm.sh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
