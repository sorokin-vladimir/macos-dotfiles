# macOS environment setup

**English** | [Русский](SETUP.ru.md)

The script that sets up everything needed to work on a fresh Mac.

## Quick start

```bash
# Go to the repository
cd ~/Documents/macos-dotfiles

# Run the script
./scripts/setup.sh
```

It asks a few questions and installs the rest. Prompts take a single keypress;
the GUI application list is an arrow-key picker.

> An SSH key has to exist **before** you run this: the repository is cloned over
> SSH. The script never creates one, it only checks.
> See [README.md](../README.md#step-0-ssh-key).

## What the script does

### 1. Install Xcode Command Line Tools and Homebrew

- Installs the Xcode Command Line Tools if `xcode-select -p` finds none, and waits for the system dialog to finish
- Checks whether Homebrew is already there
- Installs it if not
- Sets up PATH for Apple Silicon

### 2. Install packages via Homebrew

**CLI tools (always installed):**

- `mise` - runtime and tool version manager (an asdf replacement)
- `thefuck` - fixes the previous mistyped command
- `gnupg` - GPG, for signing commits
- `git` - macOS ships its own via the Xcode Command Line Tools, but it lags noticeably: 2.50.1 against 2.55.0 in brew. No PATH entry needed - the formula is not keg-only and `/opt/homebrew/bin` already comes first, so the brew build shadows the system one on its own
- `tlrc` - simplified man pages (a tldr client)
- `translate-shell` - translation in the terminal
- `neovim` - text editor
- `zsh-autosuggestions` - command autosuggestions in zsh
- `zsh-syntax-highlighting` - command syntax highlighting
- `fd` - fast file search
- `fzf` - fuzzy finder
- `ripgrep` - fast grep
- `lazygit` - TUI for git
- `lazysql` - TUI for databases
- `ec` - TUI 3-way git mergetool for resolving conflicts
- `gitlogue` - replays the commit history as a cinematic animation in the terminal
- `yazi` - terminal file manager
- `ast-grep` - code search and refactoring over the AST
- `bat` - cat with syntax highlighting
- `lla` - an `ls` replacement with several view modes (tree, timeline, git) and a plugin system
- `btop` - system resource monitor
- `ncdu` - interactive disk usage analysis
- `tokei` - counts lines of code by language
- `curl` - keg-only in Homebrew, because macOS ships its own. `.zshrc` puts `/opt/homebrew/opt/curl/bin` first on PATH, otherwise the brew build goes unused. Differences from the system one: OpenSSL instead of LibreSSL, HTTP/3, brotli, zstd
- `pnpm` - Node package manager (`.zshrc` sets up `PNPM_HOME`)
- `gh` - GitHub CLI
- `glow` - Markdown rendering in the terminal
- `golangci-lint` - Go linter
- `goreleaser` - building and publishing Go releases
- `unar` - archive extraction
- `tele` - TUI Telegram client (homebrew-core)
- `tele-beta` (tap `sorokin-vladimir/tap`) - the beta channel of `tele`, installed as a `tele-beta` binary so it can live next to the stable one
- `weathr` (tap `veirt/veirt`) - terminal weather app with ASCII animations; not in homebrew-core, so the script trusts `veirt/veirt` and then taps it
- `lsoff` (tap `yutat23/tap`) - CLI/TUI that shows which processes are listening on TCP/UDP ports and can kill the one holding a port; not in homebrew-core, so the script trusts `yutat23/tap` and then taps it

Third-party taps are trusted before `brew tap`, not after. Since Homebrew 6
`brew tap` loads every formula of the tap to validate it, refuses the untrusted
ones and fails with `invalid syntax in tap!`.

**Not installed by the script (install by hand when you want it):**

- `gittype` - typing game that turns the source of the current repository into typing challenges: `brew install gittype`

**Claude Code CLI (asks first):**

- `claude` - terminal AI coding assistant from Anthropic
- Native install: self-updating, lands in `~/.local/bin/claude`
- Afterwards run: `claude auth login`

**GUI applications (arrow keys to move, `space` toggles, `a` selects all, `enter` confirms, `q` skips):**

Selected by default:

- `anki` - spaced repetition
- `claude` - Claude Desktop from Anthropic
- `firefox` - browser
- `zen` - browser (formerly `zen-browser`)
- `hey-desktop` - HEY mail client (formerly `hey`)
- `keepassxc` - password manager
- `logseq` - notes and knowledge base
- `simplenote` - plain notes
- `spotify` - music
- `telegram` - messenger
- `vlc` - media player
- `ghostty` - terminal emulator
- `raycast` - launcher, replaces Spotlight
- `bruno` - API client
- `dbeaver-community` - database client
- `neohtop` - GUI process and resource monitor (htop on steroids)
- `orbstack` - Docker and Linux containers
- `ungoogled-chromium` - browser
- `zed` - code editor
- `claude-usage-tracker` (tap `hamed-elfayome/claude-usage`) - Claude usage monitoring

Not selected by default (rarely used):

- `discord` - messenger
- `transmission` - torrent client
- `tunnelblick` - VPN client
- `zoom` - video calls

### 3. Install Oh My Zsh

- Installs Oh My Zsh (the zsh framework)
- Unattended mode, so it does not switch the shell mid-run

### 4. Copy the configs

**Shell:**

- `.zshrc` → `~/.zshrc` (the old file is backed up)
- `sorokin.zsh-theme` → `~/.oh-my-zsh/custom/themes/`

**Ghostty:**

- `config` → `~/Library/Application Support/com.mitchellh.ghostty/config`

**Neovim (asks first):**

- If `~/.config/nvim/init.lua` is missing, installs the [LazyVim starter](https://github.com/LazyVim/starter) first. The repo only holds overrides; `init.lua` and `lua/config/lazy.lua`, which load LazyVim, come from the starter
- `nvim/config/*.lua` → `~/.config/nvim/lua/config/`
- `nvim/plugins/*.lua` → `~/.config/nvim/lua/plugins/`
- `nvim/lazyvim.json` → `~/.config/nvim/lazyvim.json`

### 5. Configure Git

- Asks for `user.name` and `user.email`; Enter keeps the default
- The default is whatever git already has; on a fresh machine, Vladimir Sorokin <v.sorokin@hey.com>
- With `--non-interactive` it takes the default without asking
- Sets nvim as the default editor (`core.editor`)
- Adds the `please` alias for `push --force-with-lease`

### 6. Install Git completion

- Downloads the Git completion scripts
- Stores them in `~/.zsh/`
- Removes the stale cache (`.zcompdump`)

### 7. Set up mise

- Offers to install Node.js 24 through mise
  - Command: `mise use -g node@24`
- Offers to install global npm packages (`leaf`)
  - Command: `mise exec node@24 -- npm install -g @rivolink/leaf`. mise is activated only in `.zshrc`, so the script's bash has no `npm` on PATH
- Offers to install Go through mise
  - Command: `mise use -g go@latest`
- Offers to install Go tooling (aqua backend)
  - `mise use -g aqua:sqlc-dev/sqlc` - code generation from SQL
  - `mise use -g aqua:golang-migrate/migrate` - database migrations

### 8. Check SSH

- Only checks whether a key exists and prints instructions if it does not
- No key is generated: cloning this repository over SSH (see the README) already
  requires a working key, so this branch is unreachable in the documented flow.
  `ssh-keygen` is interactive anyway, and the public key still has to be
  registered with GitHub by hand

### 9. Keyboard layouts and shortcuts (asks first)

- Input sources: ABC and Russian - PC. The PC layout keeps comma and period next to the right Shift rather than on Shift+6 / Shift+7
- `Cmd+Space` switches to the previous input source, `Ctrl+Opt+Space` to the next one
- Spotlight shortcuts are turned off, which frees `Ctrl+Space` for Raycast
- Shortcuts apply right away; input sources fully apply after logging out and back in

## Command line options

```bash
# Show the help
./scripts/setup.sh --help

# Skip installing Homebrew (if it is already there)
./scripts/setup.sh --skip-homebrew

# Skip installing applications
./scripts/setup.sh --skip-apps

# Skip the shell setup (Oh My Zsh)
./scripts/setup.sh --skip-shell

# Skip installing Git completion
./scripts/setup.sh --skip-git-completion

# Skip keyboard layouts and shortcuts
./scripts/setup.sh --skip-macos

# Non-interactive: take the default of every question
./scripts/setup.sh --non-interactive

# Combined
./scripts/setup.sh --skip-homebrew --skip-apps --non-interactive
```

`--non-interactive` takes each question's default rather than saying yes to
everything: applications selected by default get installed, the rarely used ones
do not. The same mode kicks in automatically when stdin is not a terminal
(`curl | bash`, CI) - otherwise the script would block on `read`.

## What you still do by hand

### 1. Fonts ⚠️ REQUIRED

The script installs the font itself - it asks "Install Nerd Fonts?" and pulls
`font-monaspice-nerd-font`. By hand it is the same:

```bash
brew install --cask font-monaspice-nerd-font
```

Mind the spelling: it is `font-monaspice-nerd-font`, with an `i`. The reason is
licensing - `Monaspace` is a Reserved Font Name under the SIL OFL, so Nerd Fonts
may not ship a patched build under that name. Plain `font-monaspace` from
[github.com/githubnext/monaspace](https://github.com/githubnext/monaspace) is a
different cask with no glyphs, and the zsh theme will break with it. Ghostty is
configured for `font-family = "MonaspiceNe Nerd Font Mono"` with
`font-style = Light`. The weight has to be a separate `font-style`: a name like
`MonaspiceNe Nerd Font Mono Light` is not a family, and Ghostty silently falls
back to its built-in JetBrains Mono.

Verify the icons render: `./shell/check-nerd-fonts.sh`

### 2. Git (if you want it different)

**The script asks during setup (Enter keeps the default):**

- `user.name` - default: whatever git has, otherwise Vladimir Sorokin
- `user.email` - default: whatever git has, otherwise v.sorokin@hey.com

**Set without asking:**

- `core.editor`: nvim

**To change it later:**

```bash
# Name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Editor
git config --global core.editor "vim"

# Inspect
git config --global user.name
git config --global user.email
git config --global core.editor
```

### 3. GPG for signing commits (optional)

```bash
# Generate a GPG key
gpg --full-generate-key

# List the keys
gpg --list-secret-keys --keyid-format=long

# Configure Git
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true

# Add the public key to GitHub/GitLab
gpg --armor --export YOUR_KEY_ID
```

### 4. Restart the terminal

After installing, restart the terminal or run:

```bash
source ~/.zshrc
```

### 5. Check Neovim

After the first Neovim start, make sure everything is fine:

```bash
nvim
# Inside Neovim:
:LazyHealth
```

### 6. SSH key for GitHub/GitLab

The script does not create a key, it only checks. If there is none:

```bash
# Create it
ssh-keygen -t ed25519 -C "your@email"

# Add it to the agent; Keychain supplies the passphrase
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Copy the public key
pbcopy < ~/.ssh/id_ed25519.pub
```

No need to start your own ssh-agent: macOS already runs one through launchd.
`.zshrc` only adds the key when the agent has none.

Register it:

- GitHub: Settings → SSH and GPG keys → New SSH key
- GitLab: Preferences → SSH Keys → Add key

### 7. Claude Code CLI (if installed)

```bash
# Authenticate through the browser
claude auth login

# Check the version
claude --version

# Auto-updates are on by default
```

### 8. Ollama (for local LLMs)

```bash
# Install Ollama
brew install ollama

# Start the service
brew services start ollama

# Pull the models
ollama pull codellama:13b
ollama pull deepseek-coder:6.7b
ollama pull llama2:7b
ollama pull mistral
```

### 9. Terminal.app theme (if you use the stock terminal)

If you use Terminal.app rather than Ghostty:

1. Open Terminal → Preferences → Profiles
2. Gear button → Import...
3. Pick `terminal/sorokin.terminal-theme.terminal`
4. Set it as Default

### 10. Keyboard (if you have a kbd67mkiirgbv3)

- `misc/kbd67mkiirgbv3.layout.json` is the layout
- Import it through VIA or similar

## Verification

Check that everything works:

```bash
# CLI tools
brew --version
mise --version
thefuck --version
nvim --version
git --version

# Claude Code CLI (if installed)
claude --version

# Git settings
git config --global user.name
git config --global user.email
git config --global core.editor

# Node.js through mise
node --version
npm --version

# Shell plugins
# Type a wrong command, press ESC, then run fuck

# Aliases
alias | grep -E "(glg|gl|ter|tre|submodule)"

# Yazi
y  # should open the file manager

# Neovim
nvim  # should open with LazyVim
```

## Handy commands afterwards

```bash
# Git
glg                    # Pretty git log with a graph
gl                     # Git log without the graph
git please             # git push --force-with-lease
submodule              # Update submodules

# Translation
ter hello              # EN to RU
tre привет             # RU to EN

# Navigation
cic                    # Jump to iCloud Drive
n                      # Open neovim in the current directory
y                      # Open yazi; on exit, cd to where you ended up

# Maintenance
bupd                   # brew update && upgrade && cleanup
lg                     # lazygit

# mise
mise use node@20       # Node.js 20 for the current project
mise use -g python@3.11 # Python 3.11 globally
mise ls                # List installed tools

# thefuck
fuck                   # Fix the previous command (after ESC)
```

## Extra tools (not in the script)

These are not installed by `setup.sh`, but worth knowing about.

### grandperspective

GUI disk usage analysis with a treemap. The script only carries the CLI option
(`ncdu`).

- Install: `brew install --cask grandperspective`

### vhs

Records terminal sessions to GIF/MP4 from a script (a `.tape` file): the typed
commands, timings, theme, window size. Good for README demos - the recording is
reproducible and edited like code, with no manual re-shoots.

- Install: `brew install vhs`
- Repository: [github.com/charmbracelet/vhs](https://github.com/charmbracelet/vhs)

### nethack

The classic terminal roguelike.

- Install: `brew install nethack`

### Pake

Wraps any website into a lightweight native desktop app (macOS, Windows, Linux).
Uses Tauri/Rust rather than Electron, so the apps weigh around 5 MB.

- Install: `npm install -g pake-cli`
- Repository: [github.com/tw93/Pake](https://github.com/tw93/Pake)

### llm-checker

A CLI tool that reads your hardware (RAM, GPU, VRAM) and recommends local LLM
models that fit.

### bento-pdf

A self-hosted web app for PDFs: merge, split, compress, convert, OCR and more.
Deployed with Docker.

- Repository: [github.com/alam00000/bentopdf](https://github.com/alam00000/bentopdf)

## When something breaks

### Homebrew is not found

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Or just restart the terminal
```

### zsh completion misbehaves

```bash
# Drop the cache and reload
rm ~/.zcompdump*
source ~/.zshrc
```

### The Oh My Zsh theme does not load

```bash
# Check the theme file is there
ls ~/.oh-my-zsh/custom/themes/sorokin.zsh-theme

# Check .zshrc
grep "ZSH_THEME" ~/.zshrc
# Expected: ZSH_THEME="sorokin"
```

### The Neovim config does not work

```bash
# Wipe the config
rm -rf ~/.config/nvim

# Re-run the script to copy it back
cd ~/Documents/macos-dotfiles
./scripts/setup.sh --skip-homebrew --skip-apps --skip-shell --non-interactive

# Start Neovim - the plugins install themselves
nvim
```

### The Ghostty config is not applied

```bash
# Check the file is there
ls ~/Library/Application\ Support/com.mitchellh.ghostty/config

# Restart Ghostty, or Cmd+R
```

### GPG signing does not work

```bash
# Check GPG_TTY is set
echo $GPG_TTY

# If empty, add it to .zshrc (it should already be there):
export GPG_TTY=$(tty)

# Reload the shell
source ~/.zshrc
```

### curl is still the system one

```bash
# Should print /opt/homebrew/opt/curl/bin/curl
command -v curl

# If it says /usr/bin/curl, .zshrc did not load
source ~/.zshrc
```

### ssh-agent processes are piling up

Symptom: `pgrep -x ssh-agent | wc -l` reports dozens or hundreds.

The cause was `eval "$(ssh-agent -s)"` in `.zshrc`, which started a fresh agent
on every shell. The current config no longer does that, but old processes stay
around:

```bash
pkill -x ssh-agent   # the launchd agent survives this
source ~/.zshrc
```

## Updating the configs

To apply changes you made in the repo:

```bash
# Configs only, no package installs
./scripts/setup.sh --skip-homebrew --skip-apps --skip-shell --non-interactive

# Or by hand
cp .zshrc ~/.zshrc
cp shell/sorokin.zsh-theme ~/.oh-my-zsh/custom/themes/
cp terminal/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
source ~/.zshrc
```

## Rolling back

```bash
# Restore the old .zshrc
cp ~/.zshrc.backup ~/.zshrc

# Remove Oh My Zsh
uninstall_oh_my_zsh

# Remove the Neovim config
rm -rf ~/.config/nvim

# Remove Homebrew (careful!)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

## Where things live

```
macos-dotfiles/
├── .zshrc                            # zsh config
├── README.md                         # Overview (English)
├── README.ru.md                      # Overview (Russian)
├── LICENSE                           # MIT
├── docs/
│   ├── SETUP.md                      # This file
│   ├── SETUP.ru.md                   # This file (Russian)
│   └── HOMEBREW_AUTOUPDATE.md
├── scripts/
│   ├── setup.sh                      # The setup script
│   ├── brew_upgrade_logged.sh
│   ├── brew_upgrade_cron.sh
│   ├── install_homebrew_autoupdate.sh
│   ├── raycast_backup.sh
│   ├── raycast_restore.sh
│   └── com.user.homebrew-autoupdate.plist
├── shell/
│   ├── sorokin.zsh-theme             # Custom Oh My Zsh theme
│   └── check-nerd-fonts.sh
├── terminal/
│   ├── config                        # Ghostty config
│   └── sorokin.terminal-theme.terminal
├── nvim/
│   ├── config/                       # Keymaps and options
│   └── plugins/                      # Plugins
├── raycast/
└── misc/
    └── kbd67mkiirgbv3.layout.json    # Keyboard layout
```

## About the script

- Safe to run repeatedly - it checks what is already installed
- Backs files up before replacing them
- macOS only
- Works on Intel and Apple Silicon
- Every prompt can be skipped with a flag
- Targets the `/bin/bash` that macOS ships, which is bash 3.2 - so no
  associative arrays or anything else from bash 4+
