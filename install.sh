#!bin/bash
sudo wget https://raw.githubusercontent.com/CaddyDz/dotfiles/master/src/debian/etc/sources.list -P /etc/apt/
# Update & upgrade the system
sudo apt-get update && sudo apt-get upgrade
# Upgrade the Distro to the latest debian stretch
# Install git version control
sudo apt-get install git
# Configure git
cp .gitconfig $HOME
# Install the Z shell
sudo apt-get install zsh
# Install vim text editor
sudo apt-get install vim
# Install VLC media player
sudo apt-get install vlc
# Generate GPG Key for GIT
# automate this https://help.github.com/articles/generating-a-new-gpg-key/
