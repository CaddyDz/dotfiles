source ~/.env

plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/.aliases
source ~/.functions.sh

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
