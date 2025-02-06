# Manage youre package with fuzzy finding

Todo
- [x] `fzp -q`
- [X] `fzp -p`
- [ ] `fzp -r`
- [ ] Rework all `fzp -S`
- [ ] `fzp`
- [ ] `Make fzp one file`
- [ ] pkgbuild
## Features

  List installed packages  
  Search for packages to install from AUR and official repositories  
  Remove packages with fuzzy selection  
  Check package dependencies  
  Display files installed by packages  

## Usage

Simply run `fzp` with any of the available options to manage your packages with ease using fuzzy finding.  


`fzp -q` List all package install   
`fzp -p {package name}` Show package options (e.g., check dependencies or remove)  
`fzp -r {package name}`  Fuzzy find to remove a package  
`fzp -S [package name]` uzzy find and install a package from AUR and official repos. If a package name is provided, show packages matching the name or description (like pacman -Ss)   

## Installation

The package is not finish yet so no install methode provided, just download the repo and chmod manually the script you want to try

#### Dependencies

`fzf`
`bat`
`awk`

If i forgot one, please open a issue.
