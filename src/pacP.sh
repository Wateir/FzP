#!/bin/sh

# 1  package information
# 2	 remove package and depency
# 3  remove only the package
# 4  reinstall the package
# 5  Show binary
# 6  Downgrade
# 7  Show all file
# 8  Remove just the package and reinstall it from repo ( Show option only if package are on official repo)


selected=$(ls ./src/pacP.d | grep  -vF "$(printf '#')" | grep '.conf$' \
			| cut -d'.' -f 1 | fzf \
  --preview-window 'right:60%:wrap:noinfo' \
  --preview="grep -n preview ./src/pacP.d/$(echo '{+}').conf \
  | cut -d'=' -f 2 | sed 's/\[R\]/$1/g' | sh"\
  --info-command="grep -n info ./src/pacP.d/$(echo '{+}').conf | cut -d'=' -f 2 | sed 's/\[R\]/$1/g' | sh"\
  $2)


if [ -n "$selected" ]; then 
    grep -n action "./src/pacP.d/${selected}.conf" | cut -d'=' -f 2 | sed "s/\[R\]/$1/g" | sh
fi
