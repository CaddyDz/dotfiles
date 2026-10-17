#!/usr/bin/env bash
#
# Snapshot what is installed and configured on this Mac, so the bootstrap
# can reproduce it on a new one. Read-only: it changes nothing on the machine.
#
#   scripts/inventory.sh [output dir]   full snapshot (default: inventory/<date>/)
#   scripts/inventory.sh --diff         show which defaults keys a settings change touches
#
# This repo is public. Anything that can hold personal data (defaults exports,
# editor settings, host names, login items) goes under private/, which
# .gitignore keeps out of git. Keys, tokens and ~/.ssh or ~/.gnupg are never read.
#
# Written for the bash 3.2 that ships with macOS.

set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
	echo "inventory.sh only runs on macOS" >&2
	exit 1
fi
# As root, `defaults` would read root's preferences instead of yours
if [ "$(id -u)" -eq 0 ]; then
	echo "Run inventory.sh as your user, not with sudo" >&2
	exit 1
fi

have() { command -v "$1" >/dev/null 2>&1; }

# Write a command's output to a file. A missing tool or a failing command is
# noted in the file instead of aborting the whole snapshot.
capture() {
	local file=$1
	shift
	if ! have "$1"; then
		echo "# skipped: $1 is not installed" >"$file"
		return 0
	fi
	"$@" >"$file" 2>/dev/null || echo "# exited $?: $*" >>"$file"
}

# Export every preferences domain, with types, as XML plists into $1.
# -currentHost (per-machine) domains go in $1/currentHost.
export_defaults() {
	local dir=$1 host domain
	for host in "" "-currentHost"; do
		local target=$dir
		if [ -n "$host" ]; then
			target=$dir/currentHost
		fi
		mkdir -p "$target"
		# shellcheck disable=SC2086 # $host is empty or a single flag
		{ echo NSGlobalDomain; defaults $host domains | tr ',' '\n'; } |
			sed 's/^ *//; /^$/d' |
			while read -r domain; do
				# shellcheck disable=SC2086
				defaults $host export "$domain" - 2>/dev/null >"$target/${domain//\//_}.plist" ||
					rm -f "$target/${domain//\//_}.plist"
			done
	done
}

if [ "${1:-}" = "--diff" ]; then
	tmp=$(mktemp -d)
	trap 'rm -rf "$tmp"' EXIT
	echo "Reading current settings…"
	export_defaults "$tmp/before"
	echo "Change settings now (System Settings, Finder, Dock…), then press Enter."
	read -r
	export_defaults "$tmp/after"
	# Paths in the output name the domain, e.g. after/com.apple.dock.plist
	(cd "$tmp" && diff -ru -U 4 before after) || true
	exit 0
fi

repo=$(cd "$(dirname "$0")/.." && pwd)
out=${1:-$repo/inventory/$(date +%F)}
private=$out/private
mkdir -p "$out" "$private"

echo "Writing inventory to $out"

echo "• System"
{
	sw_vers
	echo "Architecture: $(uname -m)"
	echo "Login shell: $(dscl . -read "$HOME" UserShell | awk '{print $2}')"
} >"$out/system.txt"

echo "• Homebrew"
if have brew; then
	# Includes `mas` and `vscode` lines when those tools are installed
	brew bundle dump --describe --force --file="$out/Brewfile" ||
		echo "# brew bundle dump failed" >"$out/Brewfile"
	capture "$out/brew-taps.txt" brew tap
	capture "$out/brew-leaves.txt" brew leaves --installed-on-request
	capture "$out/brew-casks.txt" brew list --cask
else
	echo "# skipped: brew is not installed" >"$out/Brewfile"
fi

echo "• Applications"
# App bundle names installed by casks, one per line. Each `app` artifact is
# either "Name.app" or {"target": "Name.app"} when the cask renames it, and
# a target can be a path, so keep only its last component.
cask_apps=""
if have brew; then
	cask_json=$(brew info --cask --installed --json=v2 2>/dev/null || echo '{"casks":[]}')
	if have jq; then
		cask_apps=$(jq -r '.casks[].artifacts[] | select(type == "object" and has("app")) | .app[]
			| if type == "string" then . else .target // empty end | split("/") | last' <<<"$cask_json")
	elif have python3; then
		cask_apps=$(python3 -I -c '
import json, sys
for cask in json.load(sys.stdin)["casks"]:
    for artifact in cask["artifacts"]:
        if not isinstance(artifact, dict):
            continue
        for app in artifact.get("app", []):
            name = app if isinstance(app, str) else app.get("target")
            if name:
                print(name.rsplit("/", 1)[-1])' <<<"$cask_json")
	fi
fi

# source: mas (has an App Store receipt), cask (a cask installed it),
# apple (bundled with macOS) or manual (anything else: decide in MANIFEST.md)
{
	printf 'source\tapp\tbundle_id\tversion\n'
	for app in /Applications/*.app "$HOME"/Applications/*.app; do
		[ -d "$app" ] || continue
		name=$(basename "$app")
		plist=$app/Contents/Info.plist
		id=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$plist" 2>/dev/null || echo "?")
		version=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$plist" 2>/dev/null || echo "?")
		if [ -d "$app/Contents/_MASReceipt" ]; then
			source=mas
		elif printf '%s\n' "$cask_apps" | grep -qxF "$name"; then
			source=cask
		elif [[ $id == com.apple.* ]]; then
			source=apple
		else
			source=manual
		fi
		printf '%s\t%s\t%s\t%s\n' "$source" "$name" "$id" "$version"
	done
} >"$out/apps.tsv"
capture "$out/mas.txt" mas list

echo "• Language packages"
capture "$out/npm-global.txt" npm ls --global --depth=0
capture "$out/composer-global.txt" composer global show --direct
capture "$out/pipx.txt" pipx list --short
capture "$out/uv-tools.txt" uv tool list
capture "$out/cargo.txt" cargo install --list
capture "$out/gems.txt" gem list --no-versions

echo "• Editors"
capture "$out/vscode-extensions.txt" code --list-extensions
capture "$out/cursor-extensions.txt" cursor --list-extensions
for editor in Code Cursor; do
	user_dir="$HOME/Library/Application Support/$editor/User"
	[ -d "$user_dir" ] || continue
	mkdir -p "$private/$editor"
	for file in settings.json keybindings.json; do
		if [ -f "$user_dir/$file" ]; then
			cp "$user_dir/$file" "$private/$editor/"
		fi
	done
	if [ -d "$user_dir/snippets" ]; then
		cp -R "$user_dir/snippets" "$private/$editor/"
	fi
done
ls -1 "$HOME/Library/Application Support/JetBrains" >"$out/jetbrains.txt" 2>/dev/null ||
	echo "# none" >"$out/jetbrains.txt"

echo "• Fonts"
ls -1 "$HOME/Library/Fonts" >"$out/fonts.txt" 2>/dev/null || echo "# none" >"$out/fonts.txt"

echo "• Preferences (defaults)"
export_defaults "$private/defaults"
capture "$private/dock.txt" dockutil --list

echo "• Machine settings"
{
	for name in ComputerName LocalHostName HostName; do
		echo "$name: $(scutil --get "$name" 2>/dev/null || echo "(not set)")"
	done
} >"$private/hostnames.txt"
capture "$private/pmset.txt" pmset -g custom
capture "$private/login-items.txt" osascript -e \
	'tell application "System Events" to get the name of every login item'
ls -1 "$HOME/Library/LaunchAgents" >"$private/launch-agents.txt" 2>/dev/null || true
crontab -l >"$private/crontab.txt" 2>/dev/null || echo "# no crontab" >"$private/crontab.txt"
cp /etc/paths "$private/etc-paths.txt"
ls -1 /etc/paths.d >"$private/etc-paths.d.txt" 2>/dev/null || true
if [ -f /etc/pam.d/sudo_local ]; then
	cp /etc/pam.d/sudo_local "$private/pam-sudo_local.txt"
fi

echo "• Home directory"
# Which dotfiles exist and where the symlinked ones point, to spot untracked ones
(cd "$HOME" && for f in .[!.]*; do
	if [ -L "$f" ]; then
		echo "$f -> $(readlink "$f")"
	else
		echo "$f"
	fi
done) >"$private/home-dotfiles.txt"

echo
echo "Done. Apps by source:"
tail -n +2 "$out/apps.tsv" | cut -f1 | sort | uniq -c
echo
echo "Review $out before committing. $private stays out of git."
