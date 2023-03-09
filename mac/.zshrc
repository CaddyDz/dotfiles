export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="caddy"
plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/.aliases
source ~/.functions.sh
source ~/.env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
