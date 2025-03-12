PACU_OPTIONS=("Yes" "No" "Custom")

( paru -Qua > /dev/null 
paru_exit_code=$? 
checkupdates > /dev/null 
checkupdates_exit_code=$?

# If both commands return 1 (no updates or error), interrupt the program
if [[ $paru_exit_code -ne 0 && $checkupdates_exit_code -ne 0 ]]; then
    kill $(pgrep -n fzf)
    echo "No updates available, exiting the program."
    exit 15
fi
 ) &

selected=$(printf "%s\n" "${PACU_OPTIONS[@]}" | fzf \
	$1 \
	--preview "
	echo '	- Update all what needed'
	echo ''
	echo Pacman Update
	checkupdates | bat -fl yml --style grid,numbers --terminal-width \$FZF_PREVIEW_COLUMNS
	echo Paru Update
	paru -Qua | bat -fl yml --style grid,numbers --terminal-width \$FZF_PREVIEW_COLUMNS
	echo
	"\
	--preview-window 'right:70%:wrap:noinfo' \
	--bind 'focus:transform-header:echo "FzP update utility"' \
	--no-input)

if [ "$selected" = "Yes" ]; then

	sudo pacman -Syu
	paru -Syu
	echo ""
	echo "Don't forget to update zinit"
	# zsh -c zinit update --parallel 40
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
