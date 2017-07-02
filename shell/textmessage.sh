#!/usr/bin/env bash
if [[ -z "$1" ]]; then
    prettyPrint "need a subject" >&2
    exit 1
else
    MEMBER1=5551113333
    DEFAULT_RECIPENT=555111333

    FAMILY_PHONE_NUMBERS=($MEMBER1)
    declare -A NAMES_FROM_PHONE_NUMBERS
    NAMES_FROM_PHONE_NUMBERS[$MEMBER1]=Member1Name

    if [[ -z "$3" ]]; then
        #read from stdinput
        if [[ -z "$2" ]]; then
            #one arg
            #pass stdin from fxn directly into mutt as body
            if [[ -p /dev/stdin ]]; then
                prettyPrint "Texting default recipient..."
                mutt -s "$1" $DEFAULT_RECIPIENT@txt.att.net <&0 2>$LOGFILE
            else
                prettyPrint "Need stdin for the body of the message if you want to text to me." >&2
                exit 1
            fi
        else
            #two args
            #first possibility is no phone number
            if [[ -p /dev/stdin ]]; then
                #we have stdin
                if [[ "$2" == "family" ]]; then
                    for person in ${FAMILY_PHONE_NUMBERS[@]} ; do
                        prettyPrint "${NAMES_FROM_PHONE_NUMBERS[$person]} ..."
                        mutt -s "$1" "$person"@txt.att.net <&0 2>$LOGFILE
                    done
                else
                    #loop through indexes which are phone numbers of associative array
                    for number in "${!NAMES_FROM_PHONE_NUMBERS[@]}" ; do
                        #checking for string name in the associative array
                        if [[ "$2" = ${NAMES_FROM_PHONE_NUMBERS[$number]} ]]; then
                            prettyPrint "${NAMES_FROM_PHONE_NUMBERS[$number]}..."
                            mutt -s "$1" "$number@txt.att.net" <&0 2>$LOGFILE
                            exit 0
                        fi
                        #checking for number in associative
                        if [[ "$2" == $number ]]; then
                            prettyPrint "${NAMES_FROM_PHONE_NUMBERS[$number]}..."
                            break
                        fi

                    done

                    #numeric number
                    if [[ $2 =~ ^[0-9]+$ ]];then
                        if [[ "$2" == $DEFAULT_RECIPIENT ]]; then
                            prettyPrint "Texting default recipient..."
                        fi
                        mutt -s "$1" "$2"@txt.att.net <&0 2>$LOGFILE
                    else 
                        prettyPrint "Couldn't find name '$2'...Need number..." >&2
                    fi

                fi
            else
                #no stdin
                prettyPrint "Texting default recipient..."
                mutt -s "$1" $DEFAULT_RECIPIENT@txt.att.net <<< "$2" 2>$LOGFILE
            fi

        fi


    else
        #there are 3 args
        if [[ "$3" = "family" ]]; then
            for person in ${FAMILY_PHONE_NUMBERS[@]} ; do
                prettyPrint "${NAMES_FROM_PHONE_NUMBERS[$person]} ..."
                mutt -s "$1" "$person@txt.att.net" <<< "$2" 2>$LOGFILE
            done
        else
            #third arg is phone number
            #pass text from here string as body

            for number in "${!NAMES_FROM_PHONE_NUMBERS[@]}"; do
                if [[ "$3" = ${NAMES_FROM_PHONE_NUMBERS[$number]} ]]; then
                    prettyPrint "${NAMES_FROM_PHONE_NUMBERS[$number]}..."
                    mutt -s "$1" "$number@txt.att.net" <<< "$2" 2>$LOGFILE
                    exit 0

                fi
                if [[ "$3" == $number ]]; then
                    prettyPrint "${NAMES_FROM_PHONE_NUMBERS[$number]}..."
                    break
                fi
            done
            #numeric number
            if [[ $3 =~ ^[0-9]+$ ]];then
                if [[ "$3" == $DEFAULT_RECIPIENT ]]; then
                    prettyPrint "Texting default recipient..."
                fi

                mutt -s "$1" "$3@txt.att.net" <<< "$2" 2>$LOGFILE
            else 
                prettyPrint "Couldn't find name '$3'...Need number..." >&2
            fi

        fi
    fi
fi
