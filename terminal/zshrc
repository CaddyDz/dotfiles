export PATH=/usr/bin:/usr/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=/bin:/sbin:$PATH
export PATH=~/.composer/vendor/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="caddy"
plugins=(git osx composer github laravel sudo)
source $ZSH/oh-my-zsh.sh
function reset() {
	mysql -e "drop database $1;create database $1;"
}
source ~/.aliases
function dumbdb() {
    (mysqldump -u root -p $1 > $2)
}
function v() {
	(cd ~/Homestead && vagrant $1)
}
