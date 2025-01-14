#!/bin/bash

if [ -z "$1" ]; then
  echo "Missing ARG"
  echo "fzp -p [package name]"
  exit 123
fi

package="$1"

commands=(
	"echo hellow it work $package  # test # echo some other test"
    "echo some text # Show binary of this package # Some random text"
    "pacman -Qqet # Shows explicitly installed packages that are not currently required by any other package"
    "pacman -Qqen # Shows explicitly installed packages from official Arch repos only"
    "pacman -Qqem # Shows explicitly installed packages from foreign repos only (AUR, Chaotic AUR, etc) "
)

selected_command=$(printf "%s\n" "${commands[@]}" | fzf \
  --preview 'echo {} | cut -d# -f2 | xargs ' \
  --preview-window 'right:50%:wrap' \
  --reverse \
  --info=right \
  --min-height=5 | cut -d# -f1)

if [ -n "$selected_command" ]; then
    eval $selected_command
fi
