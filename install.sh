#!/usr/bin/env bash
#
# This script should be run via curl:
# curl -fsSL https://raw.githubusercontent.com/CaddyDZ/dotfiles/master/install.sh | bash
# "-fsSL": A combination of options:
#
# - "-f" or "--fail": This option tells curl to fail silently and return
# an error code if the HTTP request doesn't succeed
# (e.g., if the server returns an error status).
#
# - "-s" or "--silent": This option prevents curl from showing the progress
# meter while the request is being made. It makes the output silent,
# only showing the final result.
#
# - "-S" or "--show-error": This option makes curl show an error message if the request fails.
# - "-L" or "--location": This option tells curl to follow any redirects returned by the server. It's useful when the server responds with a redirect to another URL.

# "-e": This option, also known as "errexit" or "exit on error
# causes the shell to exit if any command within the script fails or returns
# a non-zero exit status.
set -e

# Install command line tools if not already installed
# Pre-requisites for Git and Homebrew
function installCommandLineTools() {
    echo "Checking Command Line Tools"

    # Only run if the tools are not installed yet
    # To check that verify directory exists
    if [ ! -d "/Library/Developer/CommandLineTools" ]; then
        echo "Command Line Tools not found. Installing from softwareupdate…"
        # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
        PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
        softwareupdate -i "$PROD" --verbose;
        echo "Command Line Tools installed successfully!"
    else
        echo "Command Line Tools already installed."
    fi
}

function bootstrapTerminal() {
    sudo -v # ask password beforehand
    # Hide "last login" line when starting a new terminal session
    touch $HOME/.hushlogin
}

function installOMZ() {
    # Install zsh
    echo 'Install oh-my-zsh'
    echo '-----------------'
    rm -rf $HOME/.oh-my-zsh
    curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
}

function cloneRepo() {
    git clone https://github.com/CaddyDz/dotfiles ~/Code/dotfiles
}

function symLinkDotFiles() {
    ln -sf $HOME/Code/dotfiles/.vimrc
    ln -sf $HOME/Code/dotfiles/.env $HOME/.env
    ln -sf $HOME/Code/dotfiles/.zshrc $HOME/.zshrc
    ln -sf $HOME/Code/dotfiles/.my.cnf $HOME/.my.cnf
    ln -sf $HOME/Code/dotfiles/.aliases $HOME/.aliases
    ln -sf $HOME/Code/dotfiles/.gitconfig $HOME/.gitconfig
    ln -sf $HOME/Code/dotfiles/.functions.sh $HOME/.functions.sh
    ln -sf $HOME/Code/dotfiles/.gitignore_global $HOME/.gitignore_global
}

function installAll() {
    bootstrapTerminal
    installCommandLineTools
    cloneRepo
    installOMZ
    symLinkDotFiles
    unset bootstrapTerminal
    unset installCommandLineTools
    unset cloneRepo
    unset installOMZ
    unset symLinkDotFiles
}

if [ "$1" = "--force" -o "$1" = "-f" ]; then
    installAll
else
    echo "This may overwrite existing files in your home directory."
    echo -n "Are you sure? (y/n): "

    # Check if input is coming from a terminal
    if [ -t 0 ]; then
        read -r answer
    else
        # Read from standard input if input is redirected or piped
        read -r answer < /dev/tty
    fi

    if [ "$answer" = "y" ]; then
        installAll
    fi
fi
