# dotfiles
Some of my personal dotfiles
# ZSH terminal (zshell) theme and some cool git commands
![Terminal screenshot](https://i.imgur.com/cYM1rhc.png)

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
