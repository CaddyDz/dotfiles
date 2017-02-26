export ZSH=/home/caddy/.oh-my-zsh
ZSH_THEME="caddy"
plugins=(git debian vagrant github laravel sudo taskwarrior)
source $ZSH/oh-my-zsh.sh
alias zshconf="nano ~/.zshrc"
alias omz="cd ~/.oh-my-zsh"
alias media="cd /media/caddy/Data/"
alias mysql="mysql -u root -p"
alias dotfiles="cd ~/Documents/dotfiles/"
# Homestead Vagrant Environment Variables
function v() {
    ( cd ~/Documents/Homestead && vagrant $* )
}
# APT Package Manager Variables
function ars() {
	( sudo service apache2 restart )
}
# Daemons Managing Variables
function srv(){
	( sudo service $* )
}
