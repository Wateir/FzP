# Manage youre package with fuzzy finding

Todo
- [x] `fzp -q`
- [ ] `fzp -p`
- [ ] `fzp -r`
- [ ] `fzp -S`
- [ ] `fzp`
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
