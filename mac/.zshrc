export PATH=$HOME/.composer/vendor/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="caddy"
plugins=(git macos github sudo)
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
	httrack -F "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36" $1 -O $2 -%v -s0
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/caddy/Downloads/Programs/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/caddy/Downloads/Programs/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/caddy/Downloads/Programs/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/caddy/Downloads/Programs/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/usr/local/sbin:$PATH"
