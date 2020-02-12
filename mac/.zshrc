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
