export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git ubuntu laravel composer sudo)
source $ZSH/oh-my-zsh.sh
source ~/.aliases
source ~/.bash_aliases
source ~/.profile
# We don't need to define username and pass in Homestead
function dumpdatabase() {
	(mysqldump $1 > $2)
}
function importdatabase() {
	(mysql $1 < $2)
}
