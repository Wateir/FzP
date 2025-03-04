# Manage your package with fuzzy finding

> [!IMPORTANT]
>The project is still on early developpement, don't execpt much of it

Todo
- [X] Add a remove function to package
- [ ] Add a install methode to package
- [ ] Refractor all error code
- [ ] Make `./fzp list` faster
- [ ] Comment the code
- [ ] Finish clean custom mode
- [ ] pkgbuild

## Features

  List installed packages  
  Search for packages to install from AUR and official repositories  
  Remove packages with fuzzy selection  
  Check package dependencies  
  Display files installed by packages  

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
* The tool assume you have a propre Arch Linux installation (so with `base`)*

## Usage

Simply run `fzp` with any of the available options to manage your packages with ease using fuzzy finding.  


`./fzp list` List all package install   
`./fzp package {package name}` Show package options (e.g., check dependencies or remove)  
`./fzp remove {package name}`  Fuzzy find to remove a package  
`./fzp install {package name}` Fuzzy find and install a package from AUR and official repos. If a package name is provided, show packages matching the name or description (like pacman -Ss)   

`./fzp -s` Don't open the fuzzy finding menu on all screen

> [!NOTE]
>The usage section can not be always up to date, check `./fzp --help` for always the latest info
