source ~/.env

plugins=(git)

# Third-party completions (Homebrew, Docker Desktop) must be on fpath *before*
# oh-my-zsh runs compinit, so one compinit covers everything. Calling compinit
# again afterwards re-audits ~1000 completion files and rewrites the dump on
# every shell start (~0.45s), which is what made new tabs slow.
# $commands[brew] is a shell lookup, so no `brew --prefix` subprocess is spawned.
if (( $+commands[brew] )); then
  fpath=("${commands[brew]:h:h}/share/zsh/site-functions" $fpath)
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
# (Marker kept on purpose: Docker Desktop looks for it before appending its own
#  fpath+compinit block again. Only the fpath line is needed; omz runs compinit.)
[[ -d ~/.docker/completions ]] && fpath=(~/.docker/completions $fpath)
# End of Docker CLI completions

# No auto-update check: it ran two git calls through Apple's xcrun shim on every
# new tab (~45ms). Update manually with `omz update`.
zstyle ':omz:update' mode disabled
source $ZSH/oh-my-zsh.sh
source ~/.aliases
source ~/.functions.sh
