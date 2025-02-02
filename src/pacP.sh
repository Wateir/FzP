#!/bin/bash

#

if [ -z "$1" ]; then
  echo "Missing ARG"
  echo "fzp -p [package name]"
  exit 123
fi

# 1  package information
# 2	 remove package and depency
# 3  remove only the package
# 4  reinstall the package
# 5  Show binary
# 6  Downgrade
# 7  Show all file
# 8  Remove just the package and reinstall it from repo ( Show option only if package are on official repo)



ls ./pacP.d | cut -d'.' -f 1 | fzf \
  --preview="grep -n preview pacP.d/exemple.conf | cut -d':' -f 1 | {read n; echo $((n+1));} | xargs -I {} sed -n '{}p' pacP.d/exemple.conf | sh"\
  --preview-window 'right:60%:wrap:noinfo'\
  --reverse \
  --info=right \
  --min-height=5

if [ -n "$selected_command" ]; then
    eval $selected_command
fi


