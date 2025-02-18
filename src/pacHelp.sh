function title () {
	echo "FzP a fuzzy package manager"	
}
function description () {
	echo "Manage your package with fuzzy finding"
}
function option () {
	case "$1" in
		"list")
	    	echo "Usage : $0 [-h|s] [-a] [Argument] {parameter}"
			;;
		"package")
			echo "Usage : $0 [-h|s] [Argument] {parameter}"
			;;
		"clean")
			echo "Usage : $0 [-h|s] [-i] [Argument] {parameter}"
			;;
	esac
	
	echo ""
	echo "OPTIONS"
	echo "	-h, --help"
	echo "		this menu"
	echo "	-s"
	echo "		open it on a small window and not full screen"

	case "$1" in
			"list")
		    	echo "	-a"
		    	echo "		alias to '$0 list all'. If use, 'list' can't take parameter"
				;;
			"clean")
				echo "	-i"
				echo "		Give a custom number of old package to keep in cache to '$0 clean' {number}"
				echo "		Exept a number in [0-9]"
				;;
			"")
				echo "	-a"
				echo "		alias to '$0 list all'. If use, 'list' can't take parameter"
				echo "	-i"
				echo "		Give a custom number of old package to keep in cache to '$0 clean' {number}"
				echo "		Exept a number in [0-9]"
				;;
		esac

	

}
function argument () {
	echo "ARGUMENT"

	if [ "$1" = "list" ] || [ -z "$1" ]; then
		echo "	list {parameter}"
		echo "		Give choice between sort of package currently install"
		echo "		Optional : give a parameter to skip the choice menu"
	fi
		echo "		Valid parameter '${argumentList[@]}'"
	if [ "$1" = "package" ] || [ -z "$1" ]; then
		echo "	package"
		echo "		Option to manage a specified package"
	fi
	if [ "$1" = "clean" ] || [ -z "$1" ]; then
		echo "	clean"
		echo "		Remove unused depencies, and old package in cache"
		echo "		By default keep only the penultimate version"
	else
		echo ""
	fi
	
}


case "$1" in
		"list")
	    	title
	    	description
	    	option list
	    	argument list
			;;
		"package")
			title
			description
			option package
			argument package
			;;
		"clean")
			title
			description
			option clean
			argument clean
			;;
		"all")
			title
			description
			option
			argument
			;;
	esac
