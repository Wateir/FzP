#/bin/sh

PACC_OPTIONS=("Yes" "No" "Custom")


selected=$(printf "%s\n" "${PACC_OPTIONS[@]}" | fzf \
	$1 \
	--preview " 
			   echo \"	- Remove all not wanted dependecies\" 
			   echo \"	- Keep only penultimate version of package on cache\"
			   echo ''
			   echo \"Command execute : \"
			   echo \"pacman -Qdtq | sudo pacman -Rns\npacman -Qqd | sudo pacman -Rsu\nparu -Scc \npaccache \"-rk$2\"\" \
			   | bat -fl yml --style grid,numbers --terminal-width \$FZF_PREVIEW_COLUMNS 
			   echo ''
			   echo 'Custom :	Custom allow you to choose only some command'
			   "\
	--preview-window 'right:70%:wrap:noinfo' \
	--bind 'focus:transform-header:echo "FzP clean utility"' \
	--no-input)

if [ "$selected" = "Yes" ]; then
# Remove no longeur dependecies
#pacman -Qdtq | sudo pacman -Rns
# Remove unwanted dependecies and all they no more used dependencie too
#pacman -Qqd | sudo pacman -Rsu 
# Clean all pacman and Paru cache
#paru -Scc    
# clean cache and keep only the number of $1 last version, default one is 1 
paccache "-rk$2" 
elif [ "$selected" = "No" ]; then
	exit 0
elif [ "$selected" = "Custom" ]; then
	echo "Custom"
else
	exit 12
fi

# /var/cache/pacman/pkg/
# /var/lib/pacman/
# ~/.cache/paru/clone
# ~/.cache/paru/diff
