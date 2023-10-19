source ~/.env

plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/.aliases
source ~/.functions.sh

# Brew shell completion
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi