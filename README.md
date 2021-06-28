# dotfiles
Some of my personal dotfiles
# ZSH terminal (zshell) theme and some cool git commands
![Terminal screenshot](https://i.imgur.com/l26xLTw.png)

It contains the installation of some basic tools, some handy aliases and functions. Backups of settings are done via [Mackup](https://github.com/lra/mackup).

You can install them by cloning the repository as `.dotfiles` in your home directory and running the bootstrap script.

```
git clone git@github.com:freekmurze/dotfiles.git .dotfiles
cd .dotfiles
./bootstrap
```

The bootstrap script can be run by cd-ing into the `.dotfiles` directory and performing this command:

```bash
./bootstrap
```

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
