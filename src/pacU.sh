#/bin/sh

PACU_OPTIONS=("Yes" "No" "Custom")

if [ ! -d /tmp/fzp ]; then
	mkdir /tmp/fzp
fi

( paru -Qua > /tmp/fzp/parQua 
paru_exit_code=$? 
checkupdates > /tmp/fzp/pacQua
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
	echo '- Update all what needed'
	echo ''
	echo 'Last Systeme Update : ' $(lastUpdate '\-Syu')
	echo ''
	echo Pacman Update
	echo ''
	while true; do
		if [ -e /tmp/fzp/pacQua ]; then
	        break
	    fi
	done
	bat -f -l yml --style grid,numbers --terminal-width \$FZF_PREVIEW_COLUMNS /tmp/fzp/pacQua
	echo Paru Update
	echo ''
	bat -fl yml --style grid,numbers --terminal-width \$FZF_PREVIEW_COLUMNS /tmp/fzp/parQua
	echo
	"\
	--preview-window 'right:70%:wrap:noinfo' \
	--bind 'focus:transform-header:echo "FzP update utility"' \
	--no-input)



if [ "$selected" = "Yes" ]; then
	sudo pacman -Syu
	paru -Syu
	echo ""
	zsh -ic 'zinit update --parallel 40'
	echo ""
	echo "Done - Press enter to exit"; read

		
elif [ "$selected" = "No" ]; then

	rm -fr /tmp/fzp
	echo "End by user"
	exit 0
elif [ "$selected" = "Custom" ]; then
	echo "Custom (Not Implemented)"
else
	rm -fr /tmp/fzp
	exit 12
fi

rm -fr /tmp/fzp
