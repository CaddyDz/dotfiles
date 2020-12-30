screenfetch
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cloud"
plugins=(git ubuntu composer github laravel sudo)
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
function remove-merged-branches () {
	currentBranch=$(git rev-parse --abbrev-ref HEAD)

	read -p "Delete branches merges into $currentBranch y/N? " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		git branch --merged | grep -v $currentBranch | while read i; do git branch -d $i; done;
		echo "Branches removed successfully"
	else
		echo "Operation canceled"
	fi
}
function clone() {
	httrack -F "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36" $1 -O $2 -%v -s0
}
