#!/bin/bash
#
# Install development software.

function bootstrapTerminal() {
	sudo -v # ask password beforehand
	# Hide "last login" line when starting a new terminal session
	touch $HOME/.hushlogin
}

function installOMZ() {
	# Install zsh
	echo 'Install oh-my-zsh'
	echo '-----------------'
	rm -rf $HOME/.oh-my-zsh
	curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
}

echo 'Bootstrap terminal'
echo '------------------'
echo 'This will reset your terminal. Are you sure you want to to this? (y/n) '
read -p 'Answer: '  reply

if [[ $reply =~ ^[Yy]$ ]]
then
   bootstrapTerminal
fi
