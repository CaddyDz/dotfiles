screenfetch
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
source ~/.aliases
source ~/.bash_aliases
source ~/.profile
function dumpdb() {
        (mysqldump $1 > $2)
}
function importdb() {
        (mysql $1 < $2)
}
