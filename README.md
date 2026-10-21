# dotfiles
Some of my personal dotfiles
# ZSH terminal (zshell) theme and some cool git commands
![Terminal screenshot](https://i.imgur.com/8GVmQNA.png)

It contains the installation of some basic tools, some handy aliases and functions.

# Setup on macOS
```shell
curl -fsSL https://raw.githubusercontent.com/CaddyDZ/dotfiles/master/install.sh | bash
```
> Will prompt you for the sudo password, so inspect the script before you run

## This will:
1. Install Apple's Command Line Tools if not already installed, which are pre-requisites for Git and Homebrew.
2. Supress "last login" message on new terminal sessions.
3. Clone this repository to a new `~/Code/dotfiles` directory and symlink dotfiles to your home directory.

# Design

Decisions the bootstrap is built on. Each one names the module that implements it.

## Secrets: Bitwarden CLI, no GPG

- Nothing secret is in this repo. The private SSH keys (`id_ed25519` for GitHub auth and commit signing, plus the per-host keys) and `~/.ssh/config.local`, which names private hosts, live in Bitwarden and are restored with the `bw` CLI (`bitwarden-cli` formula). One interactive `bw login` or `bw unlock` is the only prompt; `BW_SESSION` exists only in the bootstrap process. (`install/80-secrets.sh`)
- Commit signing uses SSH (`gpg.format = ssh`, `user.signingkey = ~/.ssh/id_ed25519.pub`), so no GPG key, `gnupg` or `pinentry` is installed, ever.
- Why Bitwarden: a single brew formula with no Apple ID or iCloud sync dependency, so it works the same in a fresh VM. Decided 2026-10-17.

## Privileges: run as the user, `sudo` only for root steps

- `bootstrap.sh` runs as the normal admin user and refuses to run as root. Homebrew's installer aborts as root, and oh-my-zsh, the symlinks and `defaults` must run as the user or they land in root's home.
- It asks for the sudo password once up front (`sudo -v`) and keeps the ticket alive in a background loop for the length of the run, because macOS forgets it after 5 minutes. Root-only steps (`/etc/paths`, `/etc/pam.d/sudo_local`, `pmset`, `scutil`) are each wrapped in `sudo`. Homebrew's installer finds the cached ticket by itself. (`install/00-preflight.sh`)
- No `NOPASSWD`, permanent or temporary. The old `etc/sudoers` with `caddy ALL=(ALL) NOPASSWD:ALL` is gone. Touch ID for sudo via `/etc/pam.d/sudo_local` gives the same speed without a passwordless root on every new Mac. (`install/60-macos.sh`)
- `/etc/sudoers` is never overwritten. If a sudoers rule is ever needed, it goes in `/etc/sudoers.d/` after `visudo -cf` validation. Today nothing needs one.
- On CI (`--ci`) the runner user already has passwordless sudo, so the same script works unchanged. Decided 2026-10-21.
