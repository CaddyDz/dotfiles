# dotfiles
Some of my personal dotfiles
# ZSH terminal (zshell) theme and some cool git commands
![Terminal screenshot](https://i.imgur.com/8GVmQNA.png)

It contains the installation of some basic tools, some handy aliases and functions.

# Setup on macOS
1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew:
```shell
xcode-select --install
```
> You **DO NOT NEED** to have [XCode](https://developer.apple.com/xcode/) installed for this command to work
2. Clone repository into `~/Code/dotfiles`:
```shell
git clone https://github.com/CaddyDz/dotfiles ~/Code/dotfiles
```
> You can pick any directory you like, for example a hidden `~/.dotfiles` directory
3. Create symlinks in the home directory to the real files in the repository:
```shell
ln -sf $HOME/Code/dotfiles/.vimrc
ln -sf $HOME/Code/dotfiles/.env $HOME/.env
ln -sf $HOME/Code/dotfiles/.zshrc $HOME/.zshrc
ln -sf $HOME/Code/dotfiles/.my.cnf $HOME/.my.cnf
ln -sf $HOME/Code/dotfiles/.aliases $HOME/.aliases
ln -sf $HOME/Code/dotfiles/.hushlogin $HOME/.hushlogin
ln -sf $HOME/Code/dotfiles/.gitconfig $HOME/.gitconfig
ln -sf $HOME/Code/dotfiles/.functions.sh $HOME/.functions.sh
ln -sf $HOME/Code/dotfiles/.gitignore_global $HOME/.gitignore_global
ln -sf $HOME/Code/dotfiles/.docker/config.json $HOME/.docker/config.json
```