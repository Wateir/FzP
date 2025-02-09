# Manage youre package with fuzzy finding

The project is still on early developpement, don't execpt much of it

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


`./fzp list` List all package install   
`./fzp package {package name}` Show package options (e.g., check dependencies or remove)  
`./fzp remove {package name}`  Fuzzy find to remove a package  
`./fzp install [package name]` Fuzzy find and install a package from AUR and official repos. If a package name is provided, show packages matching the name or description (like pacman -Ss)   

## Installation

If you don't have already the dependencies
```
sudo pacman -S fzf bat awk
```

```
https://github.com/Wateir/FzP.git
cd FzP
chmod +x fzp.sh
```

#### Dependencies

`fzf`
`bat`
`awk`

If i forgot one, please open a issue.
