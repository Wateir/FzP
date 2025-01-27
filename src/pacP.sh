#!/bin/bash

#

if [ -z "$1" ]; then
  echo "Missing ARG"
  echo "fzp -p [package name]"
  exit 123
fi

# 1  package information
# 2	 remove package and depency
# 3  remove only the package
# 4  reinstall the package
# 5  Show binary
# 6  Downgrade
# 7  Show all file
# 8  Remove just the package and reinstall it from repo ( Show option only if package are on official repo)

package="$1"
#
commands=(
	"echo hellow it work $package  # test # echo some other test"
    "echo hellow2 it work $package  # test2 # echo some other test"
    "echo hellow3 it work $package  # test3 # echo some other test"
    "echo hellow4 it work $package  # test4 # echo some other test"
    "echo hellow5 it work $package  # pacman -Ql $package  # echo some other test"
)

description=(
	""
	""
	""
)

action=(
	
)


selected_command=$(printf "%s\n" "${commands[@]}" | fzf \
  --preview 'cut -d# -f2 | xargs ' \
  --preview-window 'right:60%:wrap:noinfo' \
  --reverse \
  --info=right \
  --min-height=5 | cut -d# -f1)

if [ -n "$selected_command" ]; then
    eval $selected_command
fi
