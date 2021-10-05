# dotfiles
Some of my personal dotfiles
# ZSH terminal (zshell) theme and some cool git commands
![Terminal screenshot](https://i.imgur.com/l26xLTw.png)

It contains the installation of some basic tools, some handy aliases and functions. Backups of settings are done via [Mackup](https://github.com/lra/mackup).


# Terminal
## Show profiles
dconf dump /org/gnome/terminal/legacy/profiles:/
## Export profile
dconf dump /org/gnome/terminal/legacy/profiles:/:[insert long id hash here]/ > terminal_profile.dconf
## Restore profile
dconf load /org/gnome/terminal/legacy/profiles:/:1430663d-083b-4737-a7f5-8378cc8226d1/ < terminal_profile.dconf

# Gnome
## Dump Gnome settings
cd ~
dconf dump / > saved_settings.dconf
## Load settings
cd ~
dconf load / < saved_settings.dconf
