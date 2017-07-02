#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
#####   Author: JACOBMENKE
#####   Date: Fri Jun 30 15:18:40 EDT 2017
#####   Purpose: file templates for bash, perl, python
#####   Notes: 
#}}}***********************************************************

executableScriptsProcessing(){
    # then make it executable
    if [[ ! -x "$1" ]]; then
        chmod 700 "$1"
    fi
}

addHeader(){
    #first arg is the interpreter
    #second arg is the absolute filenam
    firstString=$(cat<<EOM
#!/usr/bin/env $1
#{{{                    MARK:Header
#**************************************************************
#####   Author: JACOBMENKE
#####   Date: `date`
#####   Purpose: 
#####   Notes: 
#}}}***********************************************************
EOM
)

#add header to first argument which is the absolute path to file
echo "$firstString" > "$2"
echo >> "$2"
echo >> "$2"

}

executeTheFile(){
    addHeader "$1" "$2"
    executableScriptsProcessing "$2"
}

#if no arguments then exit
if (( $# < 1 )); then
    printf "I need an argument ...\n" >&2
    exit 1
fi

#file name is the first argument
fileToBeExecuted="$1"

case "$fileToBeExecuted" in
    *.sh ) executeTheFile bash "$fileToBeExecuted"
        ;;
    *.pl ) executeTheFile perl "$fileToBeExecuted"
        ;;
    *.rb ) executeTheFile ruby "$fileToBeExecuted"
        ;;
    *.py ) executeTheFile python3 "$fileToBeExecuted"
        ;;
    *.vim )
        command="vim -i NONE -V1 -Nes -c 'so""$fileToBeExecuted""' -c'echo""|q!' 2>&1 | tail +4"
        executeFileFirstArgIsCommand "$command" "$fileToBeExecuted" 
        ;;
    *.*)
        echo "Don't know what the run with. File ending is not recognized!" >&2
        exit 1
        ;;
    *)
        echo "Don't know what the run with! No File ending." >&2
        exit 1
        ;;
esac
