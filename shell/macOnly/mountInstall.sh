#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
##### Author: MenkeTechnologies
##### GitHub: https://github.com/MenkeTechnologies
##### Date: Mon Aug  2 20:39:01 EDT 2021
##### Purpose: bash script to install VST/VST3/AU/DMG/PKG/MPKG
##### Notes: handles EULA
#}}}***********************************************************

tempMount="/Volumes/tmp$$-$RANDOM"
blackList='m{__MACOSX} or m{(^|/)\._}'

trap clean INT

function clean() {

    sudo rm -rf "$tempMount"
    exit 0
}

function fail() {

    echo "ERROR: $@" >&2
    clean
    exit 1
}

function warn() {

    echo "WARN: $@" >&2
}

function reg() {

    printf "\x1b[0m%s\x1b[0m\n" "$*"
}

function banner() {

    printf "\x1b[1;4m%s\x1b[0m\n" "$*"
}

function bold() {

    echo
    printf "\x1b[1;4m%s\x1b[0m\n" "$*"
}

function pkgInstall(){

    dir="$1"

    while read f; do

        if ! echo "$f" | perl -ne 'exit 1 if '"$blackList"; then
            continue
        fi
        bold "---------- PKG $f ----------"
        reg "sudo installer -allowUntrusted -pkg \"$f\" -target /"
        sudo installer -allowUntrusted -pkg "$f" -target /

    done < <(find "$dir" -iname '[^.]*.mpkg' 2>/dev/null)

    while read f; do

        if ! echo "$f" | perl -ne 'exit 1 if '"$blackList"' or m{.*.mpkg/}'; then
            continue
        fi
        bold "---------- MPKG $f ----------"
        reg "sudo installer -allowUntrusted -pkg \"$f\" -target /"
        sudo installer -allowUntrusted -pkg "$f" -target /

    done < <(find "$dir" -iname '[^.]*.pkg' 2>/dev/null)
}

function vstInstall(){

    dir="$1"

    while read f; do

        if ! echo "$f" | perl -ne 'exit 1 if '"$blackList"; then
            continue
        fi
        bold "---------- VST $f ----------"
        reg "sudo cp -R \"$f\" /Library/Audio/Plug-Ins/VST"
        sudo cp -R "$f" /Library/Audio/Plug-Ins/VST

    done < <(find "$dir" -iname '[^.]*.vst' 2>/dev/null)

    while read f; do

        if ! echo "$f" | perl -ne 'exit 1 if '"$blackList"; then
            continue
        fi
        bold "---------- VST3 $f ----------"
        reg "sudo cp -R \"$f\" /Library/Audio/Plug-Ins/VST3"
        sudo cp -R "$f" /Library/Audio/Plug-Ins/VST3

    done < <(find "$dir" -iname '[^.]*.vst3' 2>/dev/null)

    while read f; do

        if ! echo "$f" | perl -ne 'exit 1 if '"$blackList"; then
            continue
        fi
        bold "---------- AU $f ----------"
        reg "sudo cp -R \"$f\" /Library/Audio/Plug-Ins/Components"
        sudo cp -R "$f" /Library/Audio/Plug-Ins/Components

    done < <(find "$dir" -iname '[^.]*.component' 2>/dev/null)
}

function main() {

    while read i; do

        if ! echo "$i" | perl -ne 'exit 1 if '"$blackList"; then
            continue
        fi

        bold "---------- DMG $i ----------"

        reg "sudo hdiutil attach -noverify -nobrowse -noautoopen -quiet -mountroot \"$tempMount\" \"$i\""

        expect <(echo '
        set timeout 5
        spawn sudo hdiutil attach -noverify -nobrowse -noautoopen -quiet -mountroot '"$tempMount"' "'"$i"'"
        expect {
            {:} {
                send {q}
                exp_continue
            }
            {(END)} {
                send {q}
                exp_continue
            }
            {Agree Y/N?} {
                send "Y\r"
            }
            eof     { puts " --- eof ---";     exit 0 }
            timeout { puts " --- timeout ---"; exit 2 }
        }
        expect {
            eof     { puts " --- eof after EULA ---";     exit 0 }
            timeout { puts " --- timeout after EULA ---"; exit 2 }
        }
    ') || {
        warn "Could not mount $i"
        continue
    }

        pkgInstall "$tempMount"
        reg "sudo hdiutil unmount -force \"$tempMount/\"*"
        sudo hdiutil unmount -force "$tempMount/"* || fail "could not unmount " "$tempMount/"*

    done < <(find "$base" -iname "*.dmg" 2>/dev/null)

    pkgInstall "$base"

    vstInstall "$base"
}

if [[ -z "$1" ]]; then
    fail "usage: mountInstall.sh <dir>"
fi

base="$1"
shift

banner "Starting VST/VST3/AU/DMG/PKG/MPKG Installer by MenkeTechnologies..."

main "$@"

clean
