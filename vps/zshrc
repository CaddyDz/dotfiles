export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cloud"
plugins=(git ubuntu composer github laravel sudo)
source $ZSH/oh-my-zsh.sh
source ~/.aliases
function dumpdatabase () {
        (mysqldump -u forge -p $1 > $2)
}

