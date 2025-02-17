#/bin/sh

# Remove no longeur dependecies
pacman -Qdtq | sudo pacman -Rns

# Remove unwanted dependecies and all they no more used dependencie too
pacman -Qqd | sudo pacman -Rsu 

# Clean all pacman and Paru cache
paru -Scc    

# clean cache and keep only the number of $1 last version, default one is 1 
paccache -rk"$1" 
