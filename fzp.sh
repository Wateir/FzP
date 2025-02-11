#!/bin/sh

FZF_OPTIONS="--info=right --reverse --min-height=5"
arguments=("install" "remove" "package" "list")


function help(){
	echo "FzP a fuzzy package manager"
	echo "	Usage : $0 [-h|s] [Argument]"
	echo "OPTIONS"
	echo "	-h, --help 	this menu"
	echo "	-s 		open it on a small window and not full screen"
	echo "ARGUMENT"
	echo "	list		Give choice between sort of package currently install"
	echo "	package		Option to manage a specified package"
	
}

if [ "$1" = "--help" ];then
	help
	exit 0
fi

while getopts "hs:" opt; do
	case "$opt" in
		h)
			help
			exit 0
			;;
		s)
			FZF_OPTIONS="$FZF_OPTIONS --height 15"
			shift
			;;
		\?)
			echo "$O : Invalid option. See '$0 --help'"
			exit 2
	esac
done

if ! echo "${arguments[@]}" | grep -qw "$1"; then
    echo "$0 : '$1' is not a $O command. See '$0 --help'"
    exit 1
fi

			
if [ "$1" = "list" ]; then
	source ./src/pacQ.sh "$FZF_OPTIONS"
elif [ "$1" = "package" ]; then
	if [ -z "$2" ]; then
		echo "$0 : Missing arguments. See '$0 --help'"
		exit 2
	else
		source ./src/pacP.sh $2	"$FZF_OPTIONS"
	fi
fi
