#!/bin/bash
export SHELL='sh'

arg=""

commands=(
	"pacman -Qq Shows all package install"
    "pacman -Qqe Shows explicitly installed packages"
    "pacman -Qqet Shows explicitly installed packages that are not currently required by any other package"
    "pacman -Qqen Shows explicitly installed packages from official Arch repos only"
    "pacman -Qqem Shows explicitly installed packages from foreign repos only (AUR, Chaotic AUR, etc)"
    "pacman -Qqd Shows implicite installed packages"
    "pacman -Qqdt Shows implicite installed packages that are not currently required by any other package"
    "pacman -Qqdn Shows implicite installed packages from official Arch repos only"
    "pacman -Qqdm Shows implicite installed packages from foreign repos only (AUR, Chaotic AUR, etc)"
)
if [ -z "$2" ]; then

	selected_command=$(printf "%s\n" "${commands[@]}" | fzf \
  		--nth ..\
  		--with-nth ..2 \
  		--preview 'printf "%s\n" {3..} | fold -w "$FZF_PREVIEW_COLUMNS" -s -; eval {..2} |
		bat -fl yml --style grid,numbers --terminal-width "$FZF_PREVIEW_COLUMNS"' \
  		--bind 'focus:transform-header:printf "Packages: %d" $(eval {..2} | wc -l) | head -5' \
  		--no-input\
  		--preview-window 'right:60%:wrap:noinfo' \
  		$1\
  		| cut -d' ' -f 2)


  	if [ -z "$selected_command" ]; then
  	exit 0
  	fi
else
	if [ "$2" = "all" ]; then
		arg=""
	else
		arg="$2"
	fi	
	selected_command="-Qq"
fi

selected_command="pacman $selected_command$arg"


if [ -n "$selected_command" ]; then
    command=$($selected_command | fzf --preview 'pacman -Qi {} | bat -fpl yml' \
    --preview-window 'right:60%:wrap:noinfo' $1)
fi

if [ -n "$command" ]; then
	source ./src/pacP.sh $command "$1"
fi
