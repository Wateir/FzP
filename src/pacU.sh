PACU_OPTIONS=("Yes" "No" "Custom")


selected=$(printf "%s\n" "${PACU_OPTIONS[@]}" | fzf \
	$1 \
	--preview "checkupdates | bat
			   "\
	--preview-window 'right:70%:wrap:noinfo' \
	--no-input)

if [ "$selected" = "Yes" ]; then

	sudo pacman -Syu
	paru -Syu
	echo "Don't forget to update zinit"

		
elif [ "$selected" = "No" ]; then
	exit 0
elif [ "$selected" = "Custom" ]; then
	echo "Custom"
else
	exit 12
fi
