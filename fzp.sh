#!/bin/sh

arguments=("install" "remove" "package" "list")


if ! echo "${arguments[@]}" | grep -qw "$1"; then
    echo "fzp : '$1' is not a fzp command. See 'fzp --help'"
    exit 1
fi

if [ "$1" = "list" ]; then
	./src/pacQ.sh
elif [ "$1" = "package" ]; then
	if [ -z "$2" ]; then
		exit 2
	else
		./src/pacP.sh $2
	fi
fi
