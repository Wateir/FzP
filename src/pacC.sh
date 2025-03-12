#/bin/sh

# Setup Variable

PACC_OPTIONS=("Yes" "No" "Custom")
PARU_DIFF=

if [ ! -d $HOME/.cache/paru/diff ]; then
	PARU_DIFF=
else
	PARU_DIFF=Yes
fi

sizepkg=$(du -s /var/cache/pacman/pkg | cut -f 1)
sizepacman=$(du  -s /var/lib/pacman | cut -f 1)
sizeclone=$(du  -s $HOME/.cache/paru/clone | cut -f 1)
if [ $PARU_DIFF ]; then
	sizediff=$(du -s $HOME/.cache/paru/diff | cut -f 1)
else
	sizediff=
fi
numberPackage=$(pacman -Qq | wc -l)


# FzF UI setup

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


# Manage fzf output

if [ "$selected" = "Yes" ]; then
# Remove no longeur dependecies
#pacman -Qdtq | sudo pacman -Rns
# Remove unwanted dependecies and all they no more used dependencie too
#pacman -Qqd | sudo pacman -Rsu 
# Clean all pacman and Paru cache
paru -Scc --noconfirm
# clean cache and keep only the number of $1 last version, default one is 1 
paccache "-rk$2" 
elif [ "$selected" = "No" ]; then
	exit 0
elif [ "$selected" = "Custom" ]; then
	echo "Custom"
else
	exit 12
fi


# Calcul of variable and the change on system size and number of package


sizepkg=$(expr $sizepkg - $(du -s /var/cache/pacman/pkg | cut -f 1))
sizepacman=$(expr $sizepacman - $(du -s /var/lib/pacman | cut -f 1))
sizeclone=$(expr $sizeclone - $(du -s $HOME/.cache/paru/clone | cut -f 1))
if [ $PARU_DIFF ]; then
	sizediff=$(expr $sizediff - $(du -s $HOME/.cache/paru/diff | cut -f 1))
elif [ -d $HOME/.cache/paru/diff ]; then
	sizediff=$(du -s $HOME/.cache/paru/diff | cut -f 1)
else
	sizediff=0
fi
size=$(expr $sizepkg + $sizepacman + $sizeclone + $sizediff)
numberPackageafter=$(pacman -Qq | wc -l)

packageRemove=$(expr $numberPackage - $numberPackageafter)


# Display of resume

echo "" 

echo "Cache remove : $size"
echo "Number of package remove : $packageRemove"
