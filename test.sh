#!/bin/bash

tmp_dir="/tmp/fzp"
mkdir -p "$tmp_dir"

list=(
  "Qqen"
  "Qqdm"
  "Qqdn"
  "Qqem"
  "Qqdt"
  "Qqet"
  "Qqd"
  "Qqe"
  "Qq"
)
for name in "${list[@]}"; do
    touch "/tmp/fzp/${name}"
    (pacman -$(echo "${name}") > "/tmp/fzp/${name}") &
done

wait

echo "done"
#ls "$tmp_dir" | fzf --preview "bat $tmp_dir/{}"
rm -rf "$tmp_dir"


# Ordre of command slowest, to fastest benchmark by hyperfine on my machine
# ( setting : 500 runs after un warmup of 10)

# pacman qqen
# pacman qqdm
# pacman qqdn
# pacman qqem
# pacman qqdt
# pacman qqet
# pacman qqd
# pacman qqe
# pacman qq

