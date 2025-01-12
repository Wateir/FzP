#!/bin/bash

if [ -z "$1" ]; then
  echo "Missing ARG"
  echo "fzp -p [package name]"
  exit 123
fi

package="$1"

echo $package

commands=(
    "pacman -Qi $package General Package info "
    "pacman -R $package Remove package"
    "pacman -Rnsu $package Remove package and dependency not longer need"
)

selected_command=$(printf "%s\n" "${commands[@]}" | fzf \
  --nth .. \
  --with-nth ..2 \
  --preview 'printf "%s\n" {4..} | fold -w "$FZF_PREVIEW_COLUMNS" -s -; eval {..2} | \
	bat -fl yml --style grid,numbers --terminal-width "$FZF_PREVIEW_COLUMNS"' \
  --preview-window 'right:60%:wrap:noinfo' \
  --reverse \
  --info-command='?' \
  --info=right \
  --min-height=5 | cut -d' ' -f-2)

# Vérification si une commande a été sélectionnée
if [ -n "$selected_command" ]; then
  
    command=$(echo "$selected_command" | cut -d ':' -f2)
    # Exécuter la commande sélectionnée
    eval $command
fi
