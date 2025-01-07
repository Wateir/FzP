#!/bin/bash

commands=(
	"pacman -Qq Shows all package install"
    "pacman -Qqe Shows explicitly installed packages"
    "pacman -Qqet Shows explicitly installed packages that are not currently required by any other package"
    "pacman -Qqen Shows explicitly installed packages from official Arch repos only"
    "pacman -Qqem Shows explicitly installed packages from foreign repos only (AUR, Chaotic AUR, etc)"
    "pacman -Qqd Show implicite installed packages"
    "pacman -Qqdt Shows implicite installed packages that are not currently required by any other package"
    "pacman -Qqdn Shows implicite installed packages from official Arch repos only"
    "pacman -Qqdm Shows implicite installed packages from foreign repos only (AUR, Chaotic AUR, etc)"
)

selected_command=$(printf "%s\n" "${commands[@]}" | fzf \
  --with-nth 1..2 \
  --preview 'echo {4..}; echo; printf "Number of packages: "; pkgs="$(eval {1..2})";\
   printf "$pkgs\n" | wc -l; echo; printf "$pkgs"\
   | bat -fl yml --terminal-width "$FZF_PREVIEW_COLUMNS" --style=grid,numbers' \
  --preview-window 'right:70%:wrap' \
  --reverse \
  --info=right \
  --min-height=5 | cut -d' ' -f-2)

if [ -n "$selected_command" ]; then
    eval $selected_command | fzf --preview 'pacman -Qil {} | bat -fpl yml' \
    --preview-window 'right:70%:wrap' \
    --layout=reverse \
    --bind 'enter:execute(pacman -Qil {} | more)'
fi
