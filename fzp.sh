#!/bin/sh

FZF_OPTIONS="--info=right --reverse --min-height=5"
PACQ_OPTIONS="0"
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
echerr() { printf "%s\n" "$*" >&2; }

if [ "$1" = "--help" ];then
	help
	exit 0
fi

while getopts "hsa:" opt; do
	case "$opt" in
		h)
			help
			exit 0
			;;
		s)
			FZF_OPTIONS="$FZF_OPTIONS --height 15"
			shift
			;;
		a)
			if [ -z "$2" ]; then
				echerr "$0 : Missing argument. See '$0 --help'"
				exit 5
			elif [ -n "$3" ]; then
				echerr "$0 : Too many arguments. See '$0 --help'"
				exit 6
			fi
			PACQ_OPTIONS="all"
			shift
			;;
		\?)
			echerr "$0 : Invalid option. See '$0 --help'"
			exit 2
	esac
done

echo $@

if ! echo "${arguments[@]}" | grep -qw "$1"; then
    echerr "$0 : '$1' is not a $O command. See '$0 --help'"
    exit 1
fi

			
if [ "$1" = "list" ]; then
	
	if [ -z "$2" ]; then
		source ./src/pacQ.sh "$FZF_OPTIONS"
	elif [ "$PACQ_OPTIONS" = "all" ]; then
		echo $PACQ_OPTIONS
		source ./src/pacQ.sh "$FZF_OPTIONS" "$PACQ_OPTIONS"
	else
		argumentList=("all" "e" "et" "en" "em" "d" "dt" "dn" "dm")
			
		if ! echo "${argumentList[@]}" | grep -qw "$2"; then
			echerr "$0 $1 : '$2' is not a $1 argument. See '$0 --help'"
			exit 4
		fi

		PACQ_OPTIONS="$2"
		source ./src/pacQ.sh "$FZF_OPTIONS" "$PACQ_OPTIONS"
	fi
	
elif [ "$1" = "package" ]; then
	if [ -z "$2" ]; then
		echerr "$0 : Missing arguments. See '$0 --help'"
		exit 3
	else
		source ./src/pacP.sh $2	"$FZF_OPTIONS"
	fi
fi
