# Inventory manifest

What the bootstrap installs and configures on a new Mac, and what it leaves out. Every row comes from the [2026-10-18 snapshot](2026-10-18/) (`scripts/inventory.sh`) or from the read-only review of that snapshot, and the `defaults` keys also from a comparison with the reinstalled Mac. Later tasks build from this file: the Brewfile (T10), oh-my-zsh (T11), links (T13), `install/60-macos.sh` (T14), app preferences (T15) and secrets (T16).

The snapshot predates the 2026-10 clean reinstall (Monterey → Ventura → Tahoe). The Mac now runs macOS Tahoe 26.7.1, which is the floor: Xcode needs 26.6 or later and Docker Desktop supports only the current release and the two before it. Xcode 27.1 is installed and active, and the host names from `hostnames.txt` are applied. Commit signing moved from GPG to SSH, so every GPG item below is dropped.

`T14` means task 14 of the bootstrap plan behind the *Mac bootstrap v1.0* milestone. `#80` means a GitHub issue in this repo.

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
| `manual T14` | Set by hand from a checklist in that task. The keys aren't stable enough to write |

## Apps

All 21 bundles in `/Applications` and `~/Applications`. The snapshot's `apps.tsv` had three wrong sources. They are corrected here (marked †).

| App | Source | Install | Notes |
|---|---|---|---|
| Claude.app | `cask` | `claude` | |
| Claude Code URL Handler.app | `drop` † | | The Claude Code CLI recreates it in `~/Applications` |
| Dark Reader for Safari.app | `mas` | id 1438243180 | No cask (Safari extension) |
| Docker.app | `cask` | `docker-desktop` | Also creates the `docker*`/`kubectl` links in `/usr/local/bin` and `~/.docker/cli-plugins` |
| GPG Keychain.app | `drop` † | | Came with the `gpg-suite-no-mail` cask. Dropped: commit signing moved to SSH, so GPG isn't used at all |
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
| git-delta | `brew` (new) | `.gitconfig` pages diffs through `delta` (`core.pager`, `interactive.diffFilter`) with line numbers. Installed 2026-10-22 |
| gnupg | `none` | Dropped. Commit signing uses SSH (`gpg.format = ssh`, key `~/.ssh/id_ed25519.pub`), so no GPG is installed |
| pinentry-mac | `none` | Dropped with gnupg |
| mas | `brew` (new) | Needed before any `mas` line runs |
| dockutil | `brew` (new) | Formula, not a cask. Rebuilds the Dock (T14) |
| bitwarden-cli | `brew` (new) | Restores SSH keys (T16). No GPG: commit signing uses SSH |

Taps: drop `homebrew/cask` and `homebrew/core` from the Brewfile. Current Homebrew warns that local clones of them are unnecessary.

## Homebrew casks

The 15 installed casks, the replacements chosen above, and fonts.

| Cask | Source | Notes |
|---|---|---|
| claude | `cask` | |
| cursor-cli | `cask` | Replaces the native install in `~/.local/share/cursor-agent`. Provides `cursor-agent` only: the native `agent` and `cursor` shims go away (nothing in the repo uses them) |
| docker-desktop | `cask` | |
| google-chrome | `cask` | Creates the Google updater LaunchAgents |
| gpg-suite-no-mail | `drop` | Dropped. Commit signing moved to SSH, so nothing replaces it |
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
| `/etc/paths.d/MacGPG2` | `drop` | Came with GPG Suite, which is dropped (signing moved to SSH) |
| `/etc/paths.d/10-cryptex`, `10-pmk-global`, `100-rvictl` | `apple` | |
| Computer, local host and host names (`hostnames.txt`) | `keep T14` | `scutil --set` |
| Power settings (`pmset.txt`) | `keep T14` | Includes `displaysleep 0` on battery and AC |
| Login items (`login-items.txt`): Rectangle, Timing Tracker | `keep T15` | |
| Dock layout | `keep T14` | `dockutil` wasn't installed, so `dock.txt` is empty. Pinned apps from `com.apple.dock` in order: Mail, Safari, Docker Desktop (`Docker.app`), Visual Studio Code, Microsoft Teams, Todoist, Music, PhpStorm, Claude, Postman, TablePlus, iTerm, Obsidian. No folders |
| User LaunchAgents (`launch-agents.txt`) | `auto` | Google updater, from the Chrome cask |
| System LaunchAgents, LaunchDaemons and privileged helpers | `auto` / `drop` | Docker items come with the `docker-desktop` cask and Microsoft items with `microsoft-auto-update`. The `org.gpgtools.*` agents and `GPGPreferences.prefPane` came with GPG Suite, which is dropped. Oracle Java and macFUSE leftovers are listed above |
| Quick Actions in `~/Library/Services` (three Claude workflows) | `auto` | Probably created by Claude.app. Check on the VM after the cask installs, and add `~/Library/Services` to `inventory.sh` (#80) |
| crontab | none | Empty |
| `~/.hushlogin` | `keep T11` | Untracked. `install.sh` creates it today |
| `~/.oh-my-zsh` | `keep T11` | Official installer. `custom/` holds only the stock examples, so there is nothing to carry over |
| `~/.zprofile` | `auto` | Only Docker Desktop's PATH block |

## Home directory state

Untracked entries in `~` (`home-dotfiles.txt`) that hold more than cache.

| Entry | Action | Notes |
|---|---|---|
| SSH private keys | `keep T16` | From the encrypted backup, never the repo. Restored by hand after the 2026-10 reinstall: `id_ed25519` (GitHub auth and signing) plus the per-host keys that `~/.ssh/config.local` references. No GPG keys |
| GPG ownertrust | `drop` | GPG is no longer used. `~/.gnupg` doesn't exist on this Mac |
| `~/.gnupg/gpg.conf`, `gpg-agent.conf` | `drop` | GPG is no longer used. `~/.gnupg` doesn't exist on this Mac |
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

The keys were classified on 2026-10-21 by comparing the snapshot with the clean Tahoe install from 2026-10-19, which stands in for macOS's own defaults:

- A key that still has its snapshot value is `keep T14`. It was either set again after the reinstall or written by Tahoe itself, and writing it again is harmless either way.
- A key the reinstall reset is `keep T14` only where the old value was wanted back. Otherwise it is `drop` and stays at Tahoe's default.
- Units, temperature, first weekday and 24-hour time follow the Region chosen in Setup Assistant: `drop`.

This replaces the per-area `inventory.sh --diff` runs. `--diff` is still the way to find the key behind a setting that isn't listed here. Values in the `keep T14` rows are the ones T14 writes.

| Domain | Keys | Action | Notes |
|---|---|---|---|
| NSGlobalDomain | `KeyRepeat` 2, `InitialKeyRepeat` 30, `NSAutomaticSpellingCorrectionEnabled` / `WebAutomaticSpellingCorrectionEnabled` false, `NSAutomaticQuoteSubstitutionEnabled` / `NSAutomaticDashSubstitutionEnabled` / `NSAutomaticPeriodSubstitutionEnabled` false, `NSAutomaticCapitalizationEnabled` true, `AppleInterfaceStyleSwitchesAutomatically` true, `AppleKeyboardUIMode` 2, `com.apple.trackpad.scaling` 0.875, `com.apple.trackpad.forceClick` false, `com.apple.sound.uiaudio.enabled` 0, `NSTableViewDefaultSizeMode` 3 | `keep T14` | `NSTableViewDefaultSizeMode` was 2 in the snapshot. 3 (large sidebar icons) is the current choice |
| NSGlobalDomain | `AppleICUForce24HourTime`, `AppleFirstWeekday`, `AppleMeasurementUnits`, `AppleMetricUnits`, `AppleTemperatureUnit` | `drop` | The Region sets them |
| NSGlobalDomain | `NSAutomaticTextCompletionEnabled`, `com.apple.keyboard.fnState`, `com.apple.sound.beep.sound`, `NSQuitAlwaysKeepsWindows`, `UIPreferredContentSizeCategoryName`, `AppleActionOnDoubleClick` | `drop` | |
| NSGlobalDomain, `-currentHost` | `com.apple.mouse.tapBehavior` 1, and the `com.apple.trackpad.*` gesture keys with the same values as the trackpad domains | `keep T14` | Tap to click needs `tapBehavior` here as well as `Clicking` |
| com.apple.AppleMultitouchTrackpad, com.apple.driver.AppleBluetoothMultitouch.trackpad | `Clicking` true, `TrackpadRightClick` true, `TrackpadThreeFingerDrag` false, `Dragging` false, `FirstClickThreshold` 1, 3- and 4-finger swipes 2 (Spaces and Mission Control), `TrackpadTwoFingerDoubleTapGesture` 1 | `keep T14` | Write both domains |
| com.apple.AppleMultitouchTrackpad, com.apple.driver.AppleBluetoothMultitouch.trackpad | `ActuationStrength` | `drop` | Silent clicking stays off |
| com.apple.AppleMultitouchMouse, com.apple.driver.AppleBluetoothMultitouch.mouse | `MouseButtonMode` OneButton, `MouseTwoFingerDoubleTapGesture` 3, `MouseTwoFingerHorizSwipeGesture` 2 | `keep T14` | Write both domains |
| com.apple.dock | `autohide` true, `tilesize` 64, `show-recents` false, `launchanim` false, `minimize-to-application` true, `showAppExposeGestureEnabled` false | `keep T14` | The pinned apps are under [Machine settings](#machine-settings) |
| com.apple.dock | `magnification`, `largesize`, `wvous-br-corner`, `mru-spaces` | `drop` | Magnification had no effect: `largesize` 30 is smaller than `tilesize`. The bottom-right hot corner keeps Tahoe's Quick Note. `mru-spaces` was never set |
| com.apple.finder | `FXPreferredViewStyle` icnv, `NewWindowTarget` PfHm, `FXDefaultSearchScope` SCcf, `FXEnableExtensionChangeWarning` false, `WarnOnEmptyTrash` false, `FXRemoveOldTrashItems` true, `ShowExternalHardDrivesOnDesktop` / `ShowRemovableMediaOnDesktop` true, `ShowHardDrivesOnDesktop` false, `ShowRecentTags` false | `keep T14` | iCloud Desktop & Documents is an iCloud setting, not a key to write |
| com.apple.finder | `FontSizeCategory`, `ShowMountedServersOnDesktop` | `drop` | |
| com.apple.screencapture | `style` window | `keep T14` | `location` and `type` stay unset (Desktop, PNG) |
| com.apple.screencapture | `target-screenshot` | `drop` | |
| com.apple.menuextra.clock | `ShowDayOfWeek` true, `ShowDate` 1 (Always) | `keep T14` | Tahoe replaced `ShowDayOfMonth` with `ShowDate` |
| com.apple.menuextra.clock | `Show24Hour`, `ShowSeconds`, `ShowDayOfMonth` | `drop` | The Region sets 24-hour time |
| com.apple.controlcenter (and `-currentHost`) | Menu bar items, `BatteryShowPercentage` | `manual T14` | Tahoe stores these under new keys (`NSStatusItem Visible*`, `VisibleCC *`) that change between releases. In System Settings → Menu Bar, hide Bluetooth, Now Playing, Screen Mirroring and FaceTime, and leave the battery percentage off |
| com.apple.WindowManager | `EnableStandardClickToShowDesktop` false, `StandardHideWidgets` true, `EnableTiledWindowMargins` false | `keep T14` | |
| com.apple.WindowManager | `GloballyEnabled` | `drop` | Stage Manager is off by default |
| com.apple.HIToolbox | `AppleEnabledInputSources`, `AppleSelectedInputSources` | `keep T14` | The values stay private. Copy them from this Mac's live domain |
| com.apple.HIToolbox | `AppleFnUsageType` | `drop` | The Globe key keeps Tahoe's default |
| com.apple.symbolichotkeys | all | `drop` | The clean install's 19 entries haven't changed since Setup Assistant, so no shortcut was customized again |
| com.apple.screensaver, `-currentHost` | `idleTime` 0 (never) | `keep T14` | |
| com.apple.screensaver, `-currentHost` | `showClock` | `drop` | |
| com.apple.loginwindow | `TALLogoutSavesState` | `drop` | Windows reopen at login, Tahoe's default |
| com.apple.universalaccess | all | `drop` | Only default values seen |
| com.apple.spaces | all | `drop` | Only the live Spaces layout |
| com.apple.desktopservices | none set | `drop` | `DSDontWriteNetworkStores` / `DSDontWriteUSBStores` would be new settings, not restored ones |
| com.apple.SoftwareUpdate | all | `drop` | Only notification state |
| com.apple.LaunchServices | all | `drop` | About 60 default-app handlers in the live file (not in the snapshot), many for removed apps. A curated `duti` list would be new work, not a restore |
| com.apple.Safari, com.apple.TextEdit | all | `drop` | Empty exports. Their preferences are in sandbox containers, out of reach of `defaults` |
