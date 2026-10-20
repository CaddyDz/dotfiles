#!/usr/bin/env bash
#
# Link the dotfiles listed in the `links` manifest into $HOME.
#
#   scripts/link.sh            create or fix every link
#   scripts/link.sh --dry-run  print what would change, change nothing
#
# Idempotent: a link that already points at the right source is left alone.
# A real file or directory in the way is moved to ~/.dotfiles-backup/<ts>/
# first, keeping its path relative to $HOME. A link pointing elsewhere is
# replaced without a backup.
#
# Written for the bash 3.2 that ships with macOS.

set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
manifest=$repo/links
backup=$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)
dry_run=false

if [ "${1:-}" = "--dry-run" ]; then
	dry_run=true
fi
if [ "$(id -u)" -eq 0 ]; then
	echo "Run link.sh as your user, not with sudo" >&2
	exit 1
fi

# Run a command, or only print it with --dry-run
run() {
	if $dry_run; then
		echo "  would run: $*"
	else
		"$@"
	fi
}

changed=0
while IFS= read -r line || [ -n "$line" ]; do
	case $line in '' | '#'*) continue ;; esac
	source=$repo/${line%% -> *}
	target=$HOME/${line#* -> }

	if [ ! -e "$source" ]; then
		echo "missing source: ${source#"$repo"/}" >&2
		exit 1
	fi
	if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
		continue
	fi

	echo "link ~/${target#"$HOME"/} -> ${source#"$repo"/}"
	run mkdir -p "$(dirname "$target")"
	if [ -L "$target" ]; then
		run rm "$target"
	elif [ -e "$target" ]; then
		run mkdir -p "$backup/$(dirname "${target#"$HOME"/}")"
		run mv "$target" "$backup/${target#"$HOME"/}"
		$dry_run || echo "  backed up to ${backup/#$HOME/~}/${target#"$HOME"/}"
	fi
	# -n: never follow an existing link to a directory and link inside it
	run ln -sn "$source" "$target"
	changed=$((changed + 1))
done <"$manifest"

# ssh refuses a config that others can write to
run chmod 700 "$HOME/.ssh"
run chmod 600 "$repo/.ssh/config"
if [ -f "$HOME/.ssh/config.local" ]; then
	run chmod 600 "$HOME/.ssh/config.local"
fi

echo "$changed link(s) changed"
