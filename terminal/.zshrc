screenfetch
export PATH=/usr/bin:/usr/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=/bin:/sbin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="caddy"
plugins=(git debian github sudo)
source $ZSH/oh-my-zsh.sh
source ~/.aliases
function v() {
	(cd ~/Homestead && vagrant $1)
}
