# Inventory manifest

What the bootstrap installs and configures on a new Mac, and what it leaves out. Every row comes from the [2026-10-18 snapshot](2026-10-18/) (`scripts/inventory.sh`) or from the read-only review of that snapshot. Later tasks build from this file: the Brewfile (T10), oh-my-zsh (T11), links (T13), `install/60-macos.sh` (T14), app preferences (T15) and secrets (T16).

`T14` means task 14 of the bootstrap plan (the Todoist project for the *Mac bootstrap v1.0* milestone). `#80` means a GitHub issue in this repo.

This repo is public. Values that could identify the machine or its owner stay in `2026-10-18/private/` and are only referred to by file name here.

## Legend

**Packages and apps**

| Source | Meaning |
|---|---|
| `brew` | Homebrew formula, a `brew` line in the Brewfile |
| `cask` | Homebrew cask, a `cask` line |
| `mas` | Mac App Store, a `mas "…", id: …` line (needs `brew "mas"` and an Apple ID) |
| `vscode` | VS Code extension, a `vscode` line |
| `npm` | Global npm package, an `npm` line (`brew bundle` supports it) |
| `manual` | Installed outside Homebrew, with the command or URL to use |
| `apple` | Ships with macOS. Nothing to install |
| `auto` | Created by another item's installer. No line of its own |
| `none` | Not installed. Nothing to do |
| `drop` | Not reproduced on the new Mac |

`(new)` after a source means it isn't on this Mac yet and the bootstrap adds it.

**Settings**

| Action | Meaning |
|---|---|
| `keep T14` | Reproduced by the plan task with that number |
| `keep`, private | Restored from a private backup, never from this repo |
| `app` | The app restores it from its own account or sync. Nothing in the repo |
| `auto` | Created by another item's installer. No row of its own in the bootstrap |
| `drop` | Not reproduced |
| `none` | Nothing to reproduce |
| `pending` | Waiting on the `defaults` diff subtask (see [macOS defaults](#macos-defaults)) |

## Apps

All 21 bundles in `/Applications` and `~/Applications`. The snapshot's `apps.tsv` had three wrong sources. They are corrected here (marked †).

| App | Source | Install | Notes |
|---|---|---|---|
| Claude.app | `cask` | `claude` | |
| Claude Code URL Handler.app | `drop` † | | The Claude Code CLI recreates it in `~/Applications` |
| Dark Reader for Safari.app | `mas` | id 1438243180 | No cask (Safari extension) |
| Docker.app | `cask` | `docker-desktop` | Also creates the `docker*`/`kubectl` links in `/usr/local/bin` and `~/.docker/cli-plugins` |
| GPG Keychain.app | `drop` † | | Came with the `gpg-suite-no-mail` cask, which is replaced by brew `gnupg` (see [GPG](#homebrew-formulae)) |
| Google Chrome.app | `cask` | `google-chrome` | |
| GRIDLegends.app | `mas` | id 1636273501 | |
| iTerm.app | `cask` | `iterm2` | Preferences tracked in the repo (T15) |
| Microsoft Teams.app | `cask` † | `microsoft-teams` | pkg cask, needs sudo |
| Obsidian.app | `cask` | `obsidian` | |
| PhpStorm.app | `cask` | `phpstorm` | |
| Postman.app | `cask` | `postman` | |
| Rectangle.app | `cask` | `rectangle` | |
| Safari.app | `apple` | | |
| TablePlus.app | `cask` | `tableplus` | |
| Termius.app | `mas` | id 1176074088 | Cask `termius` exists too. Kept on MAS, where it is installed now |
| Timing.app | `cask` | `timing` | |
| Todoist.app | `mas` | id 585829637 | Cask `todoist-app` exists too. Kept on MAS, where it is installed now |
| Visual Studio Code.app | `cask` | `visual-studio-code` | |
| WireGuard.app | `mas` | id 1451685025 | No GUI cask. `wireguard-tools` is the CLI |
| Xcode.app | `mas` | id 497799835 | Large download. `xcodes` is the non-MAS alternative |

## Homebrew formulae

The 13 leaves, `lz4` from the dump, and what the config needs but isn't installed.

| Formula | Source | Notes |
|---|---|---|
| fastfetch | `brew` | |
| gh | `brew` | |
| glab | `brew` | |
| htop | `brew` | |
| node | `brew` | Brings `npm` |
| rsync | `brew` | |
| sshpass | `brew` | Still needed |
| tree | `brew` | |
| watch | `brew` | |
| wireguard-tools | `brew` | |
| xcodegen | `brew` | |
| lz4 | `drop` | Not a leaf. node, rsync and zstd pull it in |
| openssl@3 | `drop` | Nothing installed uses it. node and rsync use `openssl@4` |
| omlahore/tap/removemacai | `drop` | Already run on this Mac. Drop the `omlahore/tap` tap with it |
| git-lfs | `brew` (new) | `.gitconfig` has a `required` lfs filter, but git-lfs isn't installed |
| gnupg | `brew` (new) | Replaces the `gpg-suite-no-mail` cask (gpg 2.2.41 from 2023). Signs commits. Never install both: `/etc/paths` puts `/usr/local/bin` (GPG Suite's `gpg`) before `/opt/homebrew/bin`, and with `commit.gpgsign = true` a mismatched gpg/pinentry blocks every commit. On this Mac, uninstall GPG Suite when switching |
| pinentry-mac | `brew` (new) | Passphrase prompt for gnupg (T16) |
| mas | `brew` (new) | Needed before any `mas` line runs |
| dockutil | `brew` (new) | Formula, not a cask. Rebuilds the Dock (T14) |
| bitwarden-cli | `brew` (new) | Restores SSH/GPG keys (T16) |

Taps: drop `homebrew/cask` and `homebrew/core` from the Brewfile. Current Homebrew warns that local clones of them are unnecessary.

## Homebrew casks

The 15 installed casks, the replacements chosen above, and fonts.

| Cask | Source | Notes |
|---|---|---|
| claude | `cask` | |
| cursor-cli | `cask` | Replaces the native install in `~/.local/share/cursor-agent`. Provides `cursor-agent` only: the native `agent` and `cursor` shims go away (nothing in the repo uses them) |
| docker-desktop | `cask` | |
| google-chrome | `cask` | Creates the Google updater LaunchAgents |
| gpg-suite-no-mail | `drop` | Replaced by brew `gnupg` + `pinentry-mac` |
| iterm2 | `cask` | |
| microsoft-auto-update | `cask` | The Teams cask leaves Microsoft AutoUpdate out, so it is installed on its own to keep Teams updated |
| microsoft-teams | `cask` | |
| obsidian | `cask` | |
| phpstorm | `cask` | |
| postman | `cask` | |
| postman-cli | `cask` (new) | Replaces the vendor-script install in `/usr/local/bin/postman` |
| rectangle | `cask` | |
| tableplus | `cask` | |
| timing | `cask` | |
| visual-studio-code | `cask` | |
| font-fira-code | `cask` (new) | Ships `FiraCode-Retina.ttf` (plus the rest of the family) |
| font-meslo-for-powerlevel10k | `cask` (new) | Ships the four `MesloLGS NF *.ttf` files exactly. Not `font-meslo-lg-nerd-font`, whose files are named differently |

The root `Brewfile` is stale and superseded by this list. These entries in it are not installed and stay out: `cursor` (the app), `macfuse`, `font-sf-pro`, `sox`, the `homebrew/bundle` and `homebrew/services` taps, and six VS Code extensions: `anysphere.cursorpyright` and `anysphere.remote-ssh` (Cursor-only), and the PHP/Laravel set `bmewburn.vscode-intelephense-client`, `laravel.vscode-laravel`, `open-southeners.laravel-pint`, `xdebug.php-debug` (PHP work happens in PhpStorm).

## VS Code extensions

All 12 → `vscode`. Cursor.app isn't installed (only `cursor-cli`), so there are no Cursor extensions.

| Extension | Source |
|---|---|
| bradlc.vscode-tailwindcss | `vscode` |
| esbenp.prettier-vscode | `vscode` |
| mikestead.dotenv | `vscode` |
| ms-python.debugpy | `vscode` |
| ms-python.python | `vscode` |
| ms-python.vscode-pylance | `vscode` |
| ms-python.vscode-python-envs | `vscode` |
| ms-vscode-remote.remote-containers | `vscode` |
| pkief.material-icon-theme | `vscode` |
| redhat.vscode-xml | `vscode` |
| sleistner.vscode-fileutils | `vscode` |
| vue.volar | `vscode` |

## Language packages

| Package | Source | Notes |
|---|---|---|
| @playwright/mcp | `npm` | |
| @sentry/mcp-server | `npm` | |
| mcp-remote | `npm` | |
| todoist-mcp-server | `npm` | |
| npm | `drop` | Comes with node |
| Ruby gems (Jekyll plugins and deps, system Ruby 2.6) | `drop` | Jekyll is unused. The rest are macOS default gems |
| `pip --user` for Xcode's python3 3.9 (beautifulsoup4, paramiko, regex, requests) | `drop` | Ad-hoc libraries, not a Fabric setup. Reinstall in a venv when needed |
| composer, pipx, uv, cargo | none | Not installed. The composer phar is under [Tools outside Homebrew](#tools-outside-homebrew) |

## Tools outside Homebrew

Not captured by `inventory.sh` yet (#80). Found by the read-only review.

| Item | Location now | Source | Install / notes |
|---|---|---|---|
| Claude Code CLI | `~/.local/bin/claude` | `manual` | `curl -fsSL https://claude.ai/install.sh \| bash` ([docs](https://code.claude.com/docs/en/setup)). Native, so it keeps updating itself |
| Postman CLI (vendor script) | `/usr/local/bin/postman`, `/usr/local/bin/lib/`, `~/.local/bin/postman` | `drop` | Replaced by cask `postman-cli` |
| cursor-agent (native) | `~/.local/share/cursor-agent`, `~/.local/bin/{agent,cursor-agent,cursor}` | `drop` | Replaced by cask `cursor-cli` |
| devc (trailofbits/claude-code-devcontainer) | `~/.claude-devcontainer`, `~/.local/bin/devc` | `drop` | Can't run: `@devcontainers/cli` isn't installed. [Reinstall](https://github.com/trailofbits/claude-code-devcontainer) when needed |
| Obsidian CLI | `/opt/homebrew/bin/obsidian` | `auto` | The `obsidian` cask links it |
| Old Obsidian CLI link | `/usr/local/bin/obsidian` | `drop` | Root-owned link from the in-app toggle. It shadows the cask's link because `/usr/local/bin` comes first on PATH |
| composer phar | `/usr/local/bin/composer` | `drop` | No PHP on the host. PHP runs in Docker |
| sshfs (macFUSE pkg) | `/usr/local/bin/sshfs`, `sshfs.1` man page, pkg receipt `io.macfuse.installer.components.sshfs`, two `io.macfuse.*` helpers in `/Library/PrivilegedHelperTools` | `drop` | Broken: macFUSE is gone but left these behind, and `libfuse3.4.dylib` is missing |
| Jekyll binstubs | `/usr/local/bin/{listen,safe_yaml}` | `drop` | Leftovers of the gems above |
| Dangling links | `/usr/local/bin/cursor`, `/usr/local/bin/prl*` | `drop` | Cursor.app and Parallels are gone |
| Python 3.8 site-packages | `~/Library/Python/3.8` | `drop` | No interpreter |
| Wappalyzer pkg receipt | pkgutil | `drop` | No app |
| Oracle Java updater | `/Library/LaunchAgents`, `/Library/LaunchDaemons` | `drop` | No Java |
| iTerm2 shell integration | `~/.iterm2` | `drop` | Not sourced by `.zshrc` |
| Rosetta | | none | Not installed, nothing needs it |

## Fonts

| Font | Source | Notes |
|---|---|---|
| FiraCode-Retina.ttf | `cask` | `font-fira-code` |
| MesloLGS NF (Regular, Bold, Italic, Bold Italic) | `cask` | `font-meslo-for-powerlevel10k` |
| Arial Unicode.ttf (`/Library/Fonts`) | `apple` | |

## Machine settings

Values live in the named `private/` file.

| Setting | Action | Notes |
|---|---|---|
| Touch ID for sudo (`pam-sudo_local.txt`) | `keep T14` | `pam_tid.so` in `/etc/pam.d/sudo_local`, which survives OS updates |
| `/etc/paths` (`etc-paths.txt`) | `keep T14` | The repo's `etc/paths` is out of date: it lacks `/opt/homebrew/sbin`, the PhpStorm launcher dir and `~/.local/bin`, and has Homebrew after the system dirs |
| `/etc/paths.d/go` | `drop` | Points at `/usr/local/go/bin`, which doesn't exist. Remove the file |
| `/etc/paths.d/MacGPG2` | `drop` | Goes away with GPG Suite |
| `/etc/paths.d/10-cryptex`, `10-pmk-global`, `100-rvictl` | `apple` | |
| Computer, local host and host names (`hostnames.txt`) | `keep T14` | `scutil --set` |
| Power settings (`pmset.txt`) | `keep T14` | Includes `displaysleep 0` on battery and AC |
| Login items (`login-items.txt`): Rectangle, Timing Tracker | `keep T15` | |
| Dock layout | `keep T14` | `dockutil` wasn't installed, so `dock.txt` is empty. Pinned apps from `com.apple.dock` in order: Mail, Safari, Docker Desktop (`Docker.app`), Visual Studio Code, Microsoft Teams, Todoist, Music, PhpStorm, Claude, Postman, TablePlus, iTerm, Obsidian. No folders |
| User LaunchAgents (`launch-agents.txt`) | `auto` | Google updater, from the Chrome cask |
| System LaunchAgents, LaunchDaemons and privileged helpers | `auto` / `drop` | Docker items come with the `docker-desktop` cask and Microsoft items with `microsoft-auto-update`. The `org.gpgtools.*` agents and `GPGPreferences.prefPane` are removed by `brew uninstall --cask gpg-suite-no-mail`. Oracle Java and macFUSE leftovers are listed above |
| Quick Actions in `~/Library/Services` (three Claude workflows) | `auto` | Probably created by Claude.app. Check on the VM after the cask installs, and add `~/Library/Services` to `inventory.sh` (#80) |
| crontab | none | Empty |
| `~/.hushlogin` | `keep T11` | Untracked. `install.sh` creates it today |
| `~/.oh-my-zsh` | `keep T11` | Official installer. `custom/` holds only the stock examples, so there is nothing to carry over |
| `~/.zprofile` | `auto` | Only Docker Desktop's PATH block |

## Home directory state

Untracked entries in `~` (`home-dotfiles.txt`) that hold more than cache.

| Entry | Action | Notes |
|---|---|---|
| SSH and GPG private keys | `keep T16` | From Bitwarden, never the repo. `~/.ssh` holds more key pairs than `id_ed25519`: decide in T16 which ones to restore |
| GPG ownertrust | `keep T16` | `gpg --export-ownertrust` into Bitwarden, or set ultimate trust on the key as T16 plans |
| `~/.gnupg/gpg.conf`, `gpg-agent.conf` | `keep T16` | Not secret. Keep `default-cache-ttl 600` and `max-cache-ttl 7200` when T16 adds the `pinentry-program` line |
| `~/.ssh/config` | `keep T13` | Already tracked as `.ssh/config` |
| `~/.ssh/known_hosts` | `drop` | |
| `~/.docker/config.json`, `daemon.json` | `keep T13` | Already tracked. `daemon.json` sets the builder GC limit |
| `~/.claude` (`CLAUDE.md`, `settings.json`, `skills/`, memory, MCP helper scripts) | `keep`, private | Personal and client context. Back it up outside this public repo |
| `~/.claude.json` (MCP servers at user and project scope) | `keep`, private | The npm MCP packages above are useless without it. Back up the `mcpServers` entries, or re-add them with `claude mcp add`. The rest of the file is cache |
| `~/.claude.json.bak-*` | `drop` | |
| `~/.vault-git` | `keep`, private | Separate git dir for the Obsidian vault. It is not in iCloud, so it doesn't come back with the vault |
| Shell and editor history: `~/.zsh_history`, `~/.zsh_sessions`, `~/.bash_history`, `~/.lesshst`, `~/.viminfo` | `drop` | |
| `~/.mcp-auth`, `~/.postman`, `~/.copilot`, `~/.cursor`, `~/.cagent`, `~/.homebrew`, `~/.swiftpm`, `~/.npm`, `~/.cache`, `~/.vscode`, `~/.vscode-shared`, `~/.local/state`, `~/.local/share/psysh`, `~/.obsidian-cli.sock`, the rest of `~/.docker` | `drop` | Auth tokens, caches and app state. Sign in again |
| JetBrains `PhpStorm2026.2` config | `app` | JetBrains Backup and Sync |
| JetBrains `PhpStorm2024.2`, `PhpStorm2024.3`, `Phpstorm`, `bl`, `consentOptions`, `crl`, `Daemon`, `discovery`, `PrivacyPolicy` (`jetbrains.txt`) | `drop` | Old versions and runtime state the IDE recreates |

## App preferences

From the per-app `defaults` domains in `private/defaults/`. None of their values go in this file.

| Domain | Action | Notes |
|---|---|---|
| com.googlecode.iterm2 | `keep T15` | Already tracked as `com.googlecode.iterm2.plist`. Load it through `PrefsCustomFolder` |
| com.knollsoft.Rectangle | `keep T15` | Shortcuts and snapping. Use Rectangle's JSON export, or a plist with the `SU*`/version keys stripped |
| com.tinyapp.TablePlus | `keep T15` | Only custom shortcuts and theme. Connections hold credentials: export them in-app, outside the repo |
| VS Code `settings.json`, `keybindings.json` (`private/Code/`) | `keep T15` | Linked from the repo |
| PhpStorm | `app` | JetBrains Backup and Sync |
| info.eurocomp.Timing2 | `app` | Timing account sync. The plist holds an analytics ID |
| md.obsidian | `app` | Settings live in the vault's `.obsidian` folder |
| Chrome, Teams, Claude, Postman | `app` | Account sync |
| com.apple.Terminal | `drop` | iTerm2 is the terminal |
| ActivityMonitor | `drop` | Window state |
| Docker, GPG, Microsoft AutoUpdate, JetBrains runtime, iTerm2 private, Timing helper, updater (`ShipIt`, Keystone) domains | `drop` | State, not preferences |
| Leftovers: IINA, Tiles, Tinkerwell, tinker-desktop, Android Emulator, `388913386`, two Segment SDK caches | `drop` | Apps no longer installed. The Segment domain names embed an API key: never commit them |
| Unprefixed Apple agent domains (`corespotlightd`, `knowledge-agent`, `pbs`, `sharedfilelistd`, …) | `drop` | System state |

## macOS defaults

526 user domains and 40 `-currentHost` domains were exported. Everything outside the list below is app or system state: `drop`.

The domains below hold real preferences. Which **keys** to keep is `pending` until the subtask *Capture `defaults` diffs for trackpad, keyboard, Finder, menu bar and Mission Control* has run: a key the diff shows you changed is `keep T14`, and a key that matches the macOS default is `drop`. Until then, these are candidates with their current values.

| Domain | Candidate keys (current value) | Action |
|---|---|---|
| NSGlobalDomain | `KeyRepeat` 2, `InitialKeyRepeat` 30, `NSAutomaticSpellingCorrectionEnabled` / `WebAutomaticSpellingCorrectionEnabled` false, `NSAutomaticQuoteSubstitutionEnabled` / `NSAutomaticDashSubstitutionEnabled` / `NSAutomaticPeriodSubstitutionEnabled` false, `NSAutomaticCapitalizationEnabled` true, `NSAutomaticTextCompletionEnabled` true, `AppleInterfaceStyleSwitchesAutomatically` true, `AppleICUForce24HourTime` true, `AppleFirstWeekday` Monday, metric units and Celsius, `AppleKeyboardUIMode` 2, `AppleActionOnDoubleClick` Fill, `com.apple.keyboard.fnState` false, `com.apple.trackpad.scaling` 0.875, `com.apple.trackpad.forceClick` false, `com.apple.sound.uiaudio.enabled` 0, `com.apple.sound.beep.sound` Blow, `NSQuitAlwaysKeepsWindows` true, `NSTableViewDefaultSizeMode` 2, `UIPreferredContentSizeCategoryName` XL | `pending` |
| NSGlobalDomain, `-currentHost` | `com.apple.mouse.tapBehavior` 1, `com.apple.trackpad.*` gestures (mirrors the trackpad domains) | `pending` |
| com.apple.AppleMultitouchTrackpad, com.apple.driver.AppleBluetoothMultitouch.trackpad | `Clicking` true, `TrackpadRightClick` true, `TrackpadThreeFingerDrag` false, `Dragging` off, `FirstClickThreshold` 1, `ActuationStrength` 0, 3- and 4-finger swipes = Spaces/Mission Control, `TrackpadTwoFingerDoubleTapGesture` 1. Write both domains | `pending` |
| com.apple.AppleMultitouchMouse, com.apple.driver.AppleBluetoothMultitouch.mouse | `MouseButtonMode` OneButton, `MouseTwoFingerDoubleTapGesture` 3, `MouseTwoFingerHorizSwipeGesture` 2 | `pending` |
| com.apple.dock | `autohide` true, `tilesize` 64, `magnification` true with `largesize` 30 (smaller than `tilesize`, so it has no effect), `show-recents` false, `launchanim` false, `minimize-to-application` true, `showAppExposeGestureEnabled` false, `wvous-br-corner` 1. `mru-spaces` is unset (Spaces rearrange themselves) | `pending` |
| com.apple.finder | `FXPreferredViewStyle` icnv, `FXDefaultSearchScope` SCcf, `FXEnableExtensionChangeWarning` false, `FXRemoveOldTrashItems` true, `WarnOnEmptyTrash` false, `NewWindowTarget` PfHm, `ShowExternalHardDrivesOnDesktop` / `ShowRemovableMediaOnDesktop` true, `ShowHardDrivesOnDesktop` / `ShowMountedServersOnDesktop` false, `ShowRecentTags` false, `FontSizeCategory` L. iCloud Desktop & Documents is an iCloud setting, not a key to write | `pending` |
| com.apple.screencapture | `style` window, `target-screenshot` file. `location` and `type` are unset (Desktop, PNG) | `pending` |
| com.apple.menuextra.clock | `Show24Hour` true, `ShowDayOfWeek` true, `ShowDayOfMonth` true, `ShowSeconds` false | `pending` |
| com.apple.controlcenter (and `-currentHost`) | Menu bar items: Bluetooth, Now Playing, Screen Mirroring, FaceTime hidden; `BatteryShowPercentage` false. The visibility integers change between macOS releases | `pending` |
| com.apple.WindowManager | `GloballyEnabled` false (Stage Manager off), `EnableStandardClickToShowDesktop` false, `EnableTiledWindowMargins` false, `StandardHideWidgets` true | `pending` |
| com.apple.HIToolbox | Enabled input sources and `AppleFnUsageType` 2. Values in the private export | `pending` |
| com.apple.symbolichotkeys | 95 shortcuts, 24 disabled. Write only the IDs the diff shows changed | `pending` |
| com.apple.screensaver, `-currentHost` | `idleTime` 0 (never), `showClock` true | `pending` |
| com.apple.loginwindow | `TALLogoutSavesState` false | `pending` |
| com.apple.universalaccess | Only default values seen. No candidates | `drop` |
| com.apple.spaces | Only the live Spaces layout | `drop` |
| com.apple.desktopservices | Not set. `DSDontWriteNetworkStores` / `DSDontWriteUSBStores` would be new settings, not restored ones | `drop` |
| com.apple.SoftwareUpdate | Only notification state | `drop` |
| com.apple.LaunchServices | About 60 default-app handlers in the live file (not in the snapshot), many for removed apps. A curated `duti` list would be new work, not a restore | `drop` |
| com.apple.Safari, com.apple.TextEdit | Empty exports. Their preferences are in sandbox containers, out of reach of `defaults` | `drop` |
