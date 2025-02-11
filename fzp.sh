#!/bin/sh
arguments=("install" "remove" "package" "list")


if ! echo "${arguments[@]}" | grep -qw "$1"; then
    echo "fzp : '$1' is not a fzp command. See 'fzp --help'"
    exit 1
fi

function help(){
	echo "Usage : $0 [-h] [-s]"
	echo "-h 	this menu"
	echo "-s 	open it on a small window and not full screen"
}

FZF_OPTIONS="--info=right --reverse --min-height=5 "
			
if [ "$1" = "list" ]; then
	source ./src/pacQ.sh "$FZF_OPTIONS"
elif [ "$1" = "package" ]; then
	if [ -z "$2" ]; then
		exit 2
	else
		source ./src/pacP.sh $2	"$FZF_OPTIONS"
	fi
fi
