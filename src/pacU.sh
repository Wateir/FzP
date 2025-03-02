PACU_OPTIONS=("Yes" "No" "Custom")

if [ $(checkupdates | wc -l) -eq 0 ]; then
	echo "Nothing need update"
	exit 0
fi

selected=$(printf "%s\n" "${PACU_OPTIONS[@]}" | fzf \
	$1 \
	--preview "echo 'FzP update utility'
	echo '	- Update all what need to be update'
	checkupdates | bat -fl yml --style grid,numbers --terminal-width \$FZF_PREVIEW_COLUMNS
	"\
	--preview-window 'right:70%:wrap:noinfo' \
	--no-input)

if [ "$selected" = "Yes" ]; then

	sudo pacman -Syu
	paru -Syu
	echo ""
	echo "Don't forget to update zinit"
	echo ""
	echo "Done - Press enter to exit"; read

		
elif [ "$selected" = "No" ]; then
	echo "End by user"
	exit 0
elif [ "$selected" = "Custom" ]; then
	echo "Custom"
else
	exit 12
fi
