#!/usr/bin/env bash
#{{{ MARK:Header
#**************************************************************
##### Author: MenkeTechnologies
##### GitHub: https://github.com/MenkeTechnologies
##### Date: Wed Sep 18 15:53:09 EDT 2019
##### Purpose: bash script to run zpwr subcommands
##### Notes: escape $ in comments for perl subs
#}}}***********************************************************

ZPWR_VERBS[about]='about=show \$ZPWR_REPO_NAME banner'
ZPWR_VERBS[allsearch]='fzfAllKeybind=search all keybindings'
ZPWR_VERBS[altprettyprint]='alternatingPrettyPrint=pretty with alternating color'
ZPWR_VERBS[attach]='tmux attach-session=attach to tmux session'
ZPWR_VERBS[background]='b=run arg in background'
ZPWR_VERBS[backup]='backup=backup files'
ZPWR_VERBS[banner]='about=show \$ZPWR_REPO_NAME banner'
ZPWR_VERBS[brc]='brc=shell aliases file vim session'
ZPWR_VERBS[cd]='f=cd to directory arg'
ZPWR_VERBS[clearcache]='clearCache=clear all zpwr cache files'
ZPWR_VERBS[cleartemp]='clearTemp=clear all zpwr temp files'
ZPWR_VERBS[clearls]='clearList=clear and list the files with no args'
ZPWR_VERBS[clearlist]='clearList=clear and list the files with no args'
ZPWR_VERBS[clone]='gcl=clone and cd to arg'
ZPWR_VERBS[cloneToForked]='cloneToForked=clone \$ZPWR_REPO_NAME to \$FORKED_DIR'
ZPWR_VERBS[colorsdiff]='gsdc=colorized side diff'
ZPWR_VERBS[color2]='color2=turn on stderr filter'
ZPWR_VERBS[copycommand]='getCopyCommand=get the command to copy with system'
ZPWR_VERBS[detach]='detachall=detach from all tmux sessions'
ZPWR_VERBS[digs]='digs=run series on networking commands on arg'
ZPWR_VERBS[drivesearch]='locateFzf=search drive for file'
ZPWR_VERBS[exists]='exists=check if command is valid'
ZPWR_VERBS[emacstokens]='etok=emacs the .tokens.sh file'
ZPWR_VERBS[emacsconfig]='econf=emacs all zpwr configs'
ZPWR_VERBS[emacsall]='emacsAll=emacs all zpwr files for :argdo'
ZPWR_VERBS[emacsemacsconfig]='emacsEmacsConfig=emacs edit emacs zpwr configs'
ZPWR_VERBS[emacsscripts]='emacsScripts=emacs all zpwr scripts for :argdo'
ZPWR_VERBS[envvars]='zpwrEnvVars=list all ZPWR env vars'
ZPWR_VERBS[envsearch]='fzfEnv=search all aliases, parameters, builtins, keywords and functions'
ZPWR_VERBS[figletfonts]='figletfonts=show all figlet fonts'
ZPWR_VERBS[fordir]='fordir=run first arg in following dirs'
ZPWR_VERBS[fordirupdate]='fordirUpdate=run git updaters in following dirs'
ZPWR_VERBS[for]='fff=run first arg times for command'
ZPWR_VERBS[for10]='ff=run 10 times for command'
ZPWR_VERBS[forked]='fp=cd to ~/forkedRepos'
ZPWR_VERBS[fp]='fp=cd to ~/forkedRepos'
ZPWR_VERBS[ghcontribcount]='cgh=count of github contribs in last year'
ZPWR_VERBS[gitfordir]='zpwrForAllGitDirs=run cmd in all git dirs'
ZPWR_VERBS[gitupdatefordir]='zpwrUpdateAllGitDirs=run git updates in all git dirs'
ZPWR_VERBS[gitreposdirty]='searchDirtyGitRepos=search dirty \$ZPWR_ALL_GIT_DIRS in fzf'
ZPWR_VERBS[gitrepos]='searchAllGitRepos=search \$ZPWR_ALL_GIT_DIRS in fzf'
ZPWR_VERBS[gitemail]='changeGitEmail=change email with git filter-brancch'
ZPWR_VERBS[gitcemail]='changeGitCommitterEmail=change committer email with git filter-brancch'
ZPWR_VERBS[gitaemail]='changeGitAuthorEmail=change author email with git filter-brancch'
ZPWR_VERBS[gitcommit]='gitCommitAndPush=commit and push with arg message'
ZPWR_VERBS[gitcommits]='commits=search git commits with fzf'
ZPWR_VERBS[gitcontribcount]='contribCount=count of git contribs by author'
ZPWR_VERBS[gitcontribcountdirs]='contribCountDirs=count of git contribs by author for list of dirs'
ZPWR_VERBS[gitcontribcountlines]='contribCountLines=count of lines contributed by author'
ZPWR_VERBS[gitclearcommit]='clearGitCommit=remove matching git commits from history'
ZPWR_VERBS[gitclearcache]='clearGitCache=clear old git refs and objects'
ZPWR_VERBS[gitdir]='isGitDir=check if pwd is git dir'
ZPWR_VERBS[github]='openmygh=open github.com profile'
ZPWR_VERBS[gitignore]='gil=vim ~/.git/info/exclude'
ZPWR_VERBS[gitlargest]='largestGitFiles=show largest files stored by git in descending order'
ZPWR_VERBS[gitremotes]='allRemotes=list all git remotes'
ZPWR_VERBS[gittotallines]='totalLines=count of total line count of git files'
ZPWR_VERBS[grep]='fz=grep through pwd with ag into fzf'
ZPWR_VERBS[hidden]='cd $ZPWR_HIDDEN_DIR=go to zpwr \$ZPWR_HIDDEN_DIR'
ZPWR_VERBS[home]='cd $ZPWR=go to zpwr \$ZPWR'
ZPWR_VERBS[homeinstall]='cd $ZPWR_INSTALL=go to zpwr \$ZPWR_INSTALL'
ZPWR_VERBS[homelocal]='cd $ZPWR_LOCAL=go to zpwr \$ZPWR_LOCAL'
ZPWR_VERBS[hubcreate]='hc=create remote github repo'
ZPWR_VERBS[hubdelete]='hd=delete remote github repo'
ZPWR_VERBS[info]='clearList=get info on command type with args'
ZPWR_VERBS[install]='inst=run configure, make and make install'
ZPWR_VERBS[killmux]='tmux kill-server=kill tmux server'
ZPWR_VERBS[learn]='learn=save learning to \$ZPWR_SCHEMA_NAME.\$ZPWR_TABLE_NAME'
ZPWR_VERBS[learnsearch]='se=search for learning in \$ZPWR_SCHEMA_NAME.\$ZPWR_TABLE_NAME'
ZPWR_VERBS[ls]='listNoClear=list the files with no args'
ZPWR_VERBS[list]='listNoClear=list the files with no args'
ZPWR_VERBS[log]='logg=write to \$ZPWR_LOGFILE'
ZPWR_VERBS[logincount]='loginCount=count of logins by user'
ZPWR_VERBS[makedir]='jd=make a dir tree'
ZPWR_VERBS[makefile]='j=make a dir tree with file at end'
ZPWR_VERBS[man]='fm=fzf through man pages'
ZPWR_VERBS[open]='o=open with system'
ZPWR_VERBS[opencommand]='getOpenCommand=get the command to open with system'
ZPWR_VERBS[pastecommand]='getPasteCommand=get the command to paste with system'
ZPWR_VERBS[pi]='pi=ping all LAN devices'
ZPWR_VERBS[pir]='pir=run command on all devices'
ZPWR_VERBS[plugins]='zpl=cd to ~/.oh-my-zsh/custom/plugins'
ZPWR_VERBS[post]='post=postfix all output'
ZPWR_VERBS[pre]='pre=prefix all output'
ZPWR_VERBS[prettyprint]='prettyPrint=pretty print with color'
ZPWR_VERBS[ps]='p=ps -ef | grep arg'
ZPWR_VERBS[pygmentcolors]='pygmentcolors=show all pygment colors'
ZPWR_VERBS[recompile]='recompile=recompile all cache comps'
ZPWR_VERBS[regen]='regenAll=regen all caches'
ZPWR_VERBS[regenenv]='regenSearchEnv=regen search env to ~/.zpwr/zpwrEnv{Key,Value}.txt'
ZPWR_VERBS[regengit]='regenAllGitRepos=regen list of all git repos to ~/.zpwr/zpwrGitDirs.txt'
ZPWR_VERBS[regenkeybindings]='regenAllKeybindingsCache=regen all keybindings cache to ~/.zpwr/zpwr{All,Vim}Keybindings.txt'
ZPWR_VERBS[rmconfiglinks]='unlinkConf=remove sym links from \$ZPWR_INSTALL to \$HOME'
ZPWR_VERBS[regenconfiglinks]='regenConfigLinks=regen sym links from \$ZPWR_INSTALL to \$HOME'
ZPWR_VERBS[regenpowerline]='regenPowerlineLink=regen powerline sym link to ~/.tmux/powerline'
ZPWR_VERBS[regentags]='regenTags=regen ctags files to ~ and ~/.zpwr/scripts'
ZPWR_VERBS[regenzsh]='regenZshCompCache=regen compsys cache to ~/.zcompdump'
ZPWR_VERBS[repo]='zp=cd to \$ZPWR_REPO_NAME'
ZPWR_VERBS[return2]='return2=turn off stderr filter'
ZPWR_VERBS[reveal]='reveal=show remote repo in browser'
ZPWR_VERBS[scriptcount]='scriptCount=total number of scripts in \$ZPWR_SCRIPTS'
ZPWR_VERBS[scripts]='sc=cd to scripts directory'
ZPWR_VERBS[scriptToPDF]='scriptToPDF=convert script to PDF'
ZPWR_VERBS[search]='s=search google for args'
ZPWR_VERBS[start]='tmm_notabs=start with no tabs'
ZPWR_VERBS[starttabs]='tmm_full=start all tabs'
ZPWR_VERBS[subcommands]='zpwrVerbs=the subcommands for zpwr <tab>'
ZPWR_VERBS[subcommandscount]='numZpwrVerbs=number of choice for zpwr <tab>'
ZPWR_VERBS[tags]='zpwrTags=view zpwr tags'
ZPWR_VERBS[taillog]='lo=tail -F \$ZPWR_LOGFILE'
ZPWR_VERBS[tests]='tru=run all zpwr tests'
ZPWR_VERBS[timer]='timer=timer one or more commands'
ZPWR_VERBS[to]='to=toggle external ip'
ZPWR_VERBS[tokens]='tok=vim the .tokens.sh file'
ZPWR_VERBS[toggle]='to=toggle external ip'
ZPWR_VERBS[trc]='trc=tmux.conf vim session'
ZPWR_VERBS[update]='getrc=update zpwr custom configs'
ZPWR_VERBS[updateall]='zpwrAllUpdates=update zpwr custom configs and deps'
ZPWR_VERBS[updatedeps]='apz=update all dependencies'
ZPWR_VERBS[upload]='upload=upload with curl'
ZPWR_VERBS[urlsafe]='urlSafe=base64 encode'
ZPWR_VERBS[verbs]='zpwrVerbs=the subcommands for zpwr <tab>'
ZPWR_VERBS[verbscount]='numZpwrVerbs=number of choice for zpwr <tab>'
ZPWR_VERBS[vimall]='vimAll=vim all zpwr files for :argdo'
ZPWR_VERBS[vimconfig]='conf=edit all zpwr configs'
ZPWR_VERBS[vimscripts]='vimScripts=vim all zpwr scripts for :argdo'
ZPWR_VERBS[vimscriptedit]='scriptEdit=edit 1 or more scripts'
ZPWR_VERBS[vimrecent]='vimRecent=choose most recent vim files'
ZPWR_VERBS[sudovimrecent]='sudoVimRecent=sudo chooose most vim recent files'
ZPWR_VERBS[vimsearch]='fzfVimKeybind=search vim keybindings'
ZPWR_VERBS[vimtests]='zpt=edit all zpwr tests'
ZPWR_VERBS[vimtokens]='tok=vim the .tokens.sh file'
ZPWR_VERBS[vrc]='vrc=vimrc vim session'
ZPWR_VERBS[whiletrue]='ww=run command forever'
ZPWR_VERBS[whilesleep]='www=run command and sleep first arg seconds'
ZPWR_VERBS[web]='we=cd to web dir'
ZPWR_VERBS[zp]='zp=cd to \$ZPWR_REPO_NAME'
ZPWR_VERBS[zpwr]='zp=cd to \$ZPWR_REPO_NAME'
ZPWR_VERBS[zpz]='zpz=cd to \$ZPWR_REPO_NAME and git co, rebase and push'
ZPWR_VERBS[zrc]='zrc=zshrc vim session'
ZPWR_VERBS[zshsearch]='zshrcsearch=search zshrc for arg'

verb="$1"

if [[ -n "$verb" ]]; then
    shift
    found=false
    for k v in ${(kv)ZPWR_VERBS[@]};do

        if [[ $k == $verb ]]; then
            found=true
            cmd=${v%%=*}
            for exp in ${(s%;%)cmd}; do
                if alias $exp 1>/dev/null 2>&1;then
                    prettyPrint "Eval subcommand '$exp'"
                    eval "$exp"
                else
                    prettyPrint "Exec subcommand '$exp'"
                    eval "$exp " ${(q)@}
                fi
            done
            break
        fi
    done

    if [[ $found == false ]]; then
        prettyPrint "Unknown subcommand: '$verb'"
    fi
fi

