pi () {
	paru -Sl | awk '{print $2($4=="" ? "" : " \*")}' \
	| fzf -q "$1" -m --preview 'cat <(echo {1} | cut -d " " -f 1 | paru -Si -) \
	<(echo {1} | cut -d " " -f 1 | paru -Fl - | awk "{print $2}")' \
	| cut -d " " -f 1 | xargs -ro paru -S
}
