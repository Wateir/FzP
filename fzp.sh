#!/bin/sh

FZF_OPTIONS="--info=right --reverse --min-height=5 --header-label-pos 0 --style full"
PACQ_OPTIONS="0"
arguments=("install" "remove" "package" "list" "clean")
argumentList=("all" "e" "et" "en" "em" "d" "dt" "dn" "dm")
PACCACHE="1"

echerr() { printf "%s\n" "$*" >&2; }


if [ "$1" = "--help" ];then
	source ./src/pacHelp.sh all
	exit 0
fi

sflag=
aflag=
iflag=
hflag=

while getopts "hsai" opt; do
	case "${opt}" in
		h)
			hflag=1;;
		s)	sflag=1;;

		a)	aflag=1;;

		i)	iflag=1;;
		
		\?)
			echerr "$0 : Invalid option. See '$0 --help'"
			exit 2
			;;
	esac
done

shift $((OPTIND-1))

if [ ! -z "$hflag" ]; then
	if ! echo "${arguments[@]}" | grep -qw "$1"; then
	    source ./src/pacHelp.sh all
	    exit 0
	fi
	case "$1" in
		"list")
		 	source ./src/pacHelp.sh list
		 	exit 0
			;;
		"package")
			source ./src/pacHelp.sh package
			exit 0
			;;
		"clean")
			source ./src/pacHelp.sh clean
			exit 0
			;;
	esac
fi

if [ ! -z "$sflag" ]; then
	if [ $(tput lines) -gt 30 ]; then
		FZF_OPTIONS="$FZF_OPTIONS --height 15"
	elif [ $(tput lines) -gt 20 ]; then
		FZF_OPTIONS="$FZF_OPTIONS --height 10"
	else
		FZF_OPTIONS="$FZF_OPTIONS --height $(expr $(tput lines) / 2)"
	fi
fi

if [ ! -z "$aflag" ]; then
	if [ -z "$1" ]; then
		echerr "$0 : Missing argument. See '$0 --help'"
		exit 5
	elif ! [ "$1" = "list" ]; then
			echerr "$0 : -a can't be use with '$1'. See '$0 --help'"
			exit 7
	elif [ "$1" = "list" ] && ! [ "$#" =  "1" ]; then
		echerr "$0 : Too many arguments. See '$0 --help'"
		exit 6
	else
		PACQ_OPTIONS="-a"
	fi	
fi

if [ ! -z "$iflag" ]; then
	if [ -z "$1" ] || [ -z "$2" ]; then
		echerr "$0 : Missing argument. See '$0 --help'"
		exit 8
	elif ! [ "$1" = "clean" ]; then
		echerr "$0 : -i can't be use with '$1'. See '$0 --help'"
		exit 10
	elif [ "$1" = "clean" ] && ! [ "$#" =  "2" ]; then
		echerr "$0 : Too many arguments. See '$0 --help'"
		exit 9
	fi
	
	numb='^[0-9]+$'
	if ! [[ "$2" =~ $numb ]]; then
		echerr "$0 : '$2' is not a valid argument. See '$0 --help'"
		exit 11
	else
		PACCACHE=$2	
	fi	
fi


if ! echo "${arguments[@]}" | grep -qw "$1"; then
    echerr "$0 : '$1' is not a $O command. See '$0 --help'"
    exit 1
fi
			

case "$1" in
	"list")
	    if [ "$PACQ_OPTIONS" = "-a" ]; then
	    	source ./src/pacQ.sh "$FZF_OPTIONS" "all"
	    elif [ -z "$2" ]; then
	    	source ./src/pacQ.sh "$FZF_OPTIONS"
	    else
	    	if ! echo "${argumentList[@]}" | grep -qw "$2"; then
	    		echerr "$0 $1 : '$2' is not a $1 argument. See '$0 --help'"
	    		exit 4
	    	fi
	    	
	    	PACQ_OPTIONS="$2"
	    	source ./src/pacQ.sh "$FZF_OPTIONS" "$PACQ_OPTIONS"
	    fi	
			;;
	"package")
		if [ -z "$2" ]; then
			echerr "$0 : Missing arguments. See '$0 --help'"
			exit 3
		else
			source ./src/pacP.sh $2	"$FZF_OPTIONS"
		fi
		;;
	"clean")
		source ./src/pacC.sh "$FZF_OPTIONS" "$PACCACHE"
		;;
esac 
