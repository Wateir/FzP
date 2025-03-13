#!/bin/sh


#	 _____    ____      
#	|  ___|__|  _ \ 
#	| |_ |_  / |_) |
#	|  _| / /|  __/ 
#	|_|  /___|_| Manage your package with fuzzy finding
#
#	All the script are distribued by Wateir at https://github.com/Wateir/FzP
#
#  Program under MIT licence, see LICENSE or https://opensource.org/license/mit

# Global Variable

FZF_OPTIONS="--info=right --reverse --min-height=5 --header-label-pos 0 --style full"
PACQ_OPTIONS="0"
argumentList=("all" "e" "et" "en" "em" "d" "dt" "dn" "dm")
PACCACHE="1"

sflag=
aflag=
iflag=
hflag=

if [ "$1" = "--help" ];then
	source ./src/pacHelp.sh all
	exit 0
fi



# Manage Error, format : "error [type of error] {optional additional context}"

error() {

	echerr() { printf "%s\n" "$*" >&2; }

	message="$0 :"

	case "$1" in
		"1")
			message="$message Invalid option."
			;;
		"2")
			message="$message Invalid argument."
			;;
		"4")
			message="$message Missing argument."
			;;
		"5")
			message="$message Too many argument."
			;;
		"3")
			message="$message Invalid arguments on this context."
			;;
		"6")
			message="$message Unexpect user behavior"
	esac

	message="$message See '$0 --help'"

	echerr $message
	if [ "$2" ]; then
		echerr "==> $2"
	fi
	exit $1
}

checkFlag() {
    local condition=$1
    local err_msg=$3
    local exit_code=$2
    if eval "$condition"; then
       error "$2" "$3"
    fi
}



while getopts "hsai" opt; do
	case "${opt}" in
		h)
			hflag=1;;
		s)	
			sflag=1;;

		a)	aflag=1;;

		i)	iflag=1;;
		
		\?)
			error 1
			;;
	esac
done

shift $((OPTIND-1))


if [ ! -z "$hflag" ]; then
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
		*)
			
			source ./src/pacHelp.sh all
			exit 2
			;;
	esac
fi


if [ ! -z "$sflag" ]; then
    lines=$(tput lines)

    if [ "$lines" -gt 30 ]; then
        FZF_OPTIONS="$FZF_OPTIONS --height 15"
    elif [ "$lines" -gt 20 ]; then
        FZF_OPTIONS="$FZF_OPTIONS --height 10"
    else
        FZF_OPTIONS="$FZF_OPTIONS --height $(($lines / 2))"
    fi

fi

if [ ! -z "$aflag" ]; then
    checkFlag "[ -z \"$1\" ]" 4
    checkFlag "[ \"$1\" != \"list\" ]" 3 "-a can't be used with '$1'" 
    checkFlag "[ \"$#\" -ne 1 ]" 5
    PACQ_OPTIONS="-a"
fi

if [ ! -z "$iflag" ]; then
    checkFlag "[ -z \"$1\" ] || [ -z \"$2\" ]" 4
    checkFlag "[ \"$1\" != \"clean\" ]" 3 "-i can't be use with '$1'"
    checkFlag "[ \"$#\" -ne 2 ]" 5

    numb='^[0-9]+$'
    checkFlag "[[ ! \"$2\" =~ $numb ]]" 5
    PACCACHE=$2
fi
			

case "$1" in
	"list")
	    if [ "$PACQ_OPTIONS" = "-a" ]; then
	    	source ./src/pacQ.sh "$FZF_OPTIONS" "all"
	    elif [ -z "$2" ]; then
	    	source ./src/pacQ.sh "$FZF_OPTIONS"
	    else
	    	if ! echo "${argumentList[@]}" | grep -qw "$2"; then
	    		error 3 "'$2' is not a $1 argument."
	    	fi
	    	
	    	PACQ_OPTIONS="$2"
	    	source ./src/pacQ.sh "$FZF_OPTIONS" "$PACQ_OPTIONS"
	    fi	
			;;
	"package")
		if [ -z "$2" ]; then
			error 4
		else
			source ./src/pacP.sh $2	"$FZF_OPTIONS"
		fi
		;;
	"clean")
		source ./src/pacC.sh "$FZF_OPTIONS" "$PACCACHE"
		;;
	*)
		error 2
		;;
		
esac 
