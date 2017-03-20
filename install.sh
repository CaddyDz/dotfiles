#!bin/bash
sudo wget https://raw.githubusercontent.com/CaddyDz/dotfiles/master/src/debian/etc/sources.list -P /etc/apt/
# Update & upgrade the system
sudo apt-get update && sudo apt-get upgrade
# Install git version control
sudo apt-get install git
# Configure git
cp .gitconfig $HOME
# Install vim text editor
sudo apt-get install vim
