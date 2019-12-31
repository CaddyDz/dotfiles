neofetch
export PATH=$HOME/.config/composer/vendor/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="caddy"
plugins=(git osx github sudo wakatime)
ZSH_DISABLE_COMPFIX=true
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
