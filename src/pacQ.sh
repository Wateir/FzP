#!/bin/bash
export SHELL='sh'
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

selected_command=$(printf "%s\n" "${commands[@]}" | fzf \
  --nth .. \
  --with-nth ..2 \
  --preview 'printf "%s\n" {3..} | fold -w "$FZF_PREVIEW_COLUMNS" -s -; eval {..2} | \
	bat -fl yml --style grid,numbers --terminal-width "$FZF_PREVIEW_COLUMNS"' \
  --preview-window 'right:60%:wrap:noinfo' \
  --reverse \
  --info-command='printf "Packages: %d" $(eval {..2} | wc -l)' \
  --info=right \
  --min-height=5 | cut -d' ' -f-2)

if [ -n "$selected_command" ]; then
    command=$($selected_command | fzf --preview 'pacman -Qi {} | bat -fpl yml' \
    --preview-window 'right:70%:wrap' \
    --layout=reverse )
fi

if [ -n "$command" ]; then
	./src/pacP.sh $command
fi
