# dotfiles
Some of my personal dotfiles
# ZSH terminal (zshell) theme and some cool git commands
![Terminal screenshot](https://i.imgur.com/8GVmQNA.png)

It contains the installation of some basic tools, some handy aliases and functions.

# Setup on macOS
```shell
curl -fsSL https://raw.githubusercontent.com/CaddyDZ/dotfiles/master/install.sh | bash
```
> Will prompt you for the sudo password, so inspect the script before you run

## This will:
1- Install Apple's Command Line Tools if not already installed, which are pre-requisites for Git and Homebrew.
2- Supress "last login" message on new terminal sessions.
3- Clone this repository to a new `~/Code/dotfiles` directory and symlink dotfiles to your home directory.