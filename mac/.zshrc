export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="caddy"
plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/.aliases

function reset() {
	(mysql -e "drop database $1;create database $1")
}
