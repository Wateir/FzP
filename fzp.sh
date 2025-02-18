#!/bin/sh

FZF_OPTIONS="--info=right --reverse --min-height=5"
PACQ_OPTIONS="0"
arguments=("install" "remove" "package" "list" "clean")
argumentList=("all" "e" "et" "en" "em" "d" "dt" "dn" "dm")
PACCACHE="1"


function help(){
	echo "FzP a fuzzy package manager"
	echo "	Manage your package with fuzzy finding"
	echo "	Usage : $0 [-h|s] [-a] [-i] [Argument] {parameter}"
	echo ""
	echo " OPTIONS"
	echo "	-h, --help"
	echo "			this menu"
	echo "	-s"
	echo "			open it on a small window and not full screen"
	echo "	-a"
	echo "			alias to '$0 list all'. If use, 'list' can't take parameter"
	echo "	-i"
	echo "			Give a custom number of old package to keep in cache to '$0 clean' {number}"
	echo "			Exept a number in [0-9]"
	echo " ARGUMENT"
	echo "	list {parameter}"
	echo "			Give choice between sort of package currently install"
	echo "			Optional : give a parameter to skip the choice menu"
	echo "				Valid parameter '${argumentList[@]}'"
	echo "	package"
	echo "			Option to manage a specified package"
	echo "	clean"
	echo "			Remove unused depencies, and old package in cache"
	echo "				By default keep only the penultimate version"
	
}
echerr() { printf "%s\n" "$*" >&2; }


if [ "$1" = "--help" ];then
	help
	exit 0
fi

sflag=
aflag=
iflag=

while getopts "hsai" opt; do
	case "${opt}" in
		h)
			help
			exit 0
			;;
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


if [ ! -z "$sflag" ]; then
	if [ $(tput lines) -gt 30 ]; then
		FZF_OPTIONS="$FZF_OPTIONS --height 15"
	else
		FZF_OPTIONS="$FZF_OPTIONS --height 10"
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
			
if [ "$1" = "list" ]; then
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
elif [ "$1" = "package" ]; then
	if [ -z "$2" ]; then
		echerr "$0 : Missing arguments. See '$0 --help'"
		exit 3
	else
		source ./src/pacP.sh $2	"$FZF_OPTIONS"
	fi
elif [ "$1" = "clean" ]; then
	source ./src/pacC.sh "$FZF_OPTIONS" "$PACCACHE"
fi
 
