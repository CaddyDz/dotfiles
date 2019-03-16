screenfetch
export PATH=/usr/bin:/usr/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=/bin:/sbin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="caddy"
plugins=(git debian github sudo)
source $ZSH/oh-my-zsh.sh
source ~/.aliases
function dumpdb() {
	(mysqldump $1 > $2)
}
function importdb() {
	(mysql $1 < $2)
}
function reset() {
	(mysql -e "drop database $1;create database $1")
}
