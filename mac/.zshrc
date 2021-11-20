export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.composer/vendor/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="caddy"
plugins=(git)
source $ZSH/oh-my-zsh.sh
source ~/.aliases
function importdb() {
	(mysql $1 < $2)
}
function reset() {
	(mysql -e "drop database $1;create database $1")
}
