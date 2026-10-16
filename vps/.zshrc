screenfetch
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
export EDITOR="vim"
ZSH_THEME="cloud"
plugins=(git ubuntu composer laravel sudo)
source $ZSH/oh-my-zsh.sh
source ~/.aliases
source ~/.functions.sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
