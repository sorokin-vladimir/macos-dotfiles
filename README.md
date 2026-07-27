# macos-dotfiles

**English** | [Русский](README.ru.md)

Personal macOS development environment configuration.

## Quick start

### Step 0: SSH key

Do this **before** anything else: the repository is cloned over SSH, so a
working key has to exist before the script does. The script never creates a
key - it only checks that one is there.

```bash
# Create a key
ssh-keygen -t ed25519 -C "your@email"

# Add it to the agent; Keychain supplies the passphrase
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Copy the public key, then add it at github.com/settings/keys
pbcopy < ~/.ssh/id_ed25519.pub
```

No need to start your own `ssh-agent`: macOS already runs one through launchd.

Check that GitHub accepts the key:

```bash
ssh -T git@github.com
```

### Step 1: Clone and run

```bash
git clone git@github.com:sorokin-vladimir/macos-dotfiles.git ~/Documents/macos-dotfiles
cd ~/Documents/macos-dotfiles

./scripts/setup.sh
```

The script installs Homebrew and the tooling, configures the shell and git,
checks SSH, and copies the config files into place.

📖 Full walkthrough: **[docs/SETUP.md](docs/SETUP.md)**

## Contents

- [🐚 Shell Configuration](#-shell-configuration) - zsh with oh-my-zsh
- [🖥️ Terminal](#%EF%B8%8F-terminal) - Ghostty and Terminal.app
- [🚀 Productivity](#-productivity) - Raycast launcher
- [📝 Editors](#-editors) - Neovim
- [🔧 Scripts](#-scripts) - Automation and maintenance
- [📚 Documentation](#-documentation) - Detailed guides
- [🎹 Miscellaneous](#-miscellaneous) - Everything else

> Note: the per-component READMEs linked below are still in Russian. The two
> entry points - this file and [docs/SETUP.md](docs/SETUP.md) - are bilingual.

---

## 🐚 Shell Configuration

**Directory:** [`shell/`](shell/)

- **[.zshrc](.zshrc)** (repo root) - the main zsh config
- **[sorokin.zsh-theme](shell/sorokin.zsh-theme)** - custom theme with git indicators

**Highlights:**
- mise, thefuck, zsh-autosuggestions, zsh-syntax-highlighting
- Git aliases: `glg`, `gl`, `submodule`
- Navigation: `cic` (iCloud), `y` (yazi, cds into the directory you exit from)
- Utilities: `ter`/`tre` (translate), `n` (neovim), `lg` (lazygit), `bupd` (update brew)

📖 More: **[shell/README.md](shell/README.md)** (in Russian)

---

## 🖥️ Terminal

**Directory:** [`terminal/`](terminal/)

### Ghostty (primary)
- TokyoNight theme (Moon/Day)
- Font: MonaspiceNe Nerd Font Mono Light
- Vim-style navigation: `cmd+shift+hjkl`
- Quick terminal: `cmd+g`

### Terminal.app (legacy)
- Old theme, kept for compatibility

📖 More: **[terminal/README.md](terminal/README.md)** (in Russian)

---

## 🚀 Productivity

**Directory:** [`raycast/`](raycast/)

### Raycast - productivity launcher

A Spotlight replacement:
- Window management
- Clipboard history
- App integrations (Spotify)
- Calculator and currency conversion
- Snippets and quick notes

**Installed extensions:**
- **Spotify Player** - control Spotify from the menu bar
- **Google Translate** - quick translation
- **URL Encoder/Decoder**

**Setting up a new machine:**
```bash
./scripts/raycast_restore.sh  # Restore from backup
```

Then:
1. Disable Spotlight in System Settings
2. Confirm the `Ctrl+Space` hotkey in Raycast (it should restore automatically)

📖 More: **[raycast/README.md](raycast/README.md)** (in Russian)

---

## 📝 Editors

### Neovim + LazyVim

**Directory:** [`nvim/`](nvim/)

```
nvim/
├── config/           # Keymaps and options
│   ├── keymaps.lua
│   └── options.lua
└── plugins/          # Plugin configuration
    ├── cmp.lua
    ├── codeium.lua
    ├── colorscheme.lua
    └── surround.lua
```

**Key bindings:**
- `jj`/`kk` - leave insert mode
- `<leader>dl` - console.log
- `<leader>cP` - show the file path
- `Shift+H`/`Shift+L` - move between buffers

📖 More: **[nvim/README.md](nvim/README.md)** (in Russian)

---

## 🔧 Scripts

**Directory:** [`scripts/`](scripts/)

### setup.sh
The main environment bootstrap script.

```bash
./scripts/setup.sh                    # Full install
./scripts/setup.sh --non-interactive  # No prompts, takes the defaults
./scripts/setup.sh --skip-apps        # Skip applications
```

Prompts take a single keypress, and the GUI application list is an arrow-key
picker: `space` toggles, `a` selects all, `enter` confirms, `q` skips.

### Homebrew maintenance

**Manual update:**
```bash
./scripts/brew_upgrade_logged.sh
```

**Automatic update (launchd):**
```bash
./scripts/brew_upgrade_cron.sh                    # Dry run
./scripts/install_homebrew_autoupdate.sh          # Install (recommended)
```

It then runs daily at 11:09 and notifies about:
- How many updates are available
- Problems reported by `brew doctor`
- Whether the run succeeded

📖 More: **[scripts/README.md](scripts/README.md)** | **[docs/HOMEBREW_AUTOUPDATE.md](docs/HOMEBREW_AUTOUPDATE.md)** (in Russian)

---

## 📚 Documentation

**Directory:** [`docs/`](docs/)

- **[SETUP.md](docs/SETUP.md)** - full installation walkthrough
- **[HOMEBREW_AUTOUPDATE.md](docs/HOMEBREW_AUTOUPDATE.md)** - auto-update setup (in Russian)

---

## 🎹 Miscellaneous

**Directory:** [`misc/`](misc/)

- KBD67 MKII RGB V3 keyboard layout (VIA)

📖 More: **[misc/README.md](misc/README.md)** (in Russian)

---

## Installing the pieces by hand

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Packages

**CLI tools:**
```bash
brew install mise thefuck gnupg git tlrc translate-shell neovim \
  zsh-autosuggestions zsh-syntax-highlighting fd fzf ripgrep \
  lazygit lazysql ec gitlogue curl yazi ast-grep bat btop ncdu tokei gh glow \
  golangci-lint goreleaser unar pnpm

# Custom tap
brew tap sorokin-vladimir/tap
brew trust --tap sorokin-vladimir/tap
brew install tele tele-beta

# weathr is not in homebrew-core
brew tap veirt/veirt
brew trust --tap veirt/veirt
brew install weathr
```

Two of these need a word of explanation:

- **curl** is keg-only in Homebrew, because macOS ships its own. `.zshrc` puts
  `/opt/homebrew/opt/curl/bin` ahead on PATH, otherwise the brew build would sit
  unused. It brings OpenSSL instead of LibreSSL, plus HTTP/3, brotli and zstd.
- **git** needs no such entry: the formula is not keg-only and
  `/opt/homebrew/bin` already comes first, so it shadows the older Apple git
  that ships with the Xcode Command Line Tools.

**GUI apps:**
```bash
# Tap for Claude Usage Tracker
brew tap hamed-elfayome/claude-usage
brew trust --tap hamed-elfayome/claude-usage
brew install --cask anki claude firefox \
  zen hey-desktop keepassxc logseq simplenote spotify \
  telegram vlc ghostty raycast \
  bruno dbeaver-community neohtop \
  orbstack ungoogled-chromium zed claude-usage-tracker
```

**Rarely used:**
```bash
brew install --cask discord transmission tunnelblick zoom
```

**GUI alternative for disk usage** (not installed by the script; `ncdu` covers
this from the CLI):
```bash
brew install --cask grandperspective
```

**Typing practice** (not installed by the script - install it when you want it):
```bash
# Turns the source of the current repository into typing challenges
brew install gittype
```

### Claude Code CLI

```bash
# Native install - what setup.sh does
curl -fsSL https://claude.ai/install.sh | bash
claude auth login
```

A `claude-code` cask exists too, but the script uses the native install: it
self-updates and lands in `~/.local/bin/claude`.

### Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Fonts ⚠️ REQUIRED

```bash
# Nerd-patched Monaspace. This is what Ghostty is configured for:
# font-family = "MonaspiceNe Nerd Font Mono Light"
brew install --cask font-monaspice-nerd-font
```

Mind the spelling: the cask is `font-monaspice-nerd-font`, with an `i`. The
reason is licensing - `Monaspace` is a Reserved Font Name under the SIL OFL, so
Nerd Fonts may not ship a patched build under that name. Plain `font-monaspace`
will not do: it has none of the glyphs the zsh theme draws.

Verify the icons render: `./shell/check-nerd-fonts.sh`

Font upstream: [github.com/githubnext/monaspace](https://github.com/githubnext/monaspace)

### Git

```bash
# Force-push alias
git config --global alias.please 'push --force-with-lease'

# Git completion
mkdir -p ~/.zsh && cd ~/.zsh
curl -o git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o _git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
rm ~/.zcompdump  # After the first run
```

### Mise

```bash
mise use -g node@24
mise use -g go@latest

# Go tools (aqua backend)
mise use -g aqua:sqlc-dev/sqlc
mise use -g aqua:golang-migrate/migrate
```

### npm global packages

```bash
npm install -g @rivolink/leaf   # Terminal Markdown viewer
```

**leaf** renders Markdown in the terminal: syntax highlighting, LaTeX, a TOC
that tracks the active section, live reload, fuzzy file search, 5 themes.

### Neovim + LazyVim

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
# Add to ~/.config/nvim/init.vim: set relativenumber
nvim  # Start it and let the plugins install
:LazyHealth  # Check the health
```

### Ollama (optional)

```bash
brew install ollama
ollama pull codellama:13b
ollama pull deepseek-coder:6.7b
ollama pull llama2:7b
ollama pull mistral
```

GUI clients (not installed by the script, both are manual):
[mindMac](https://mindmac.app/) or [Msty](https://msty.app/)

---

## Repository layout

```
macos-dotfiles/
├── .zshrc                    # Main shell config
├── README.md                 # This file
├── README.ru.md              # Overview (Russian)
├── LICENSE                   # MIT
├── docs/                     # 📚 Documentation
│   ├── SETUP.md              # Installation (English)
│   ├── SETUP.ru.md           # Installation (Russian)
│   └── HOMEBREW_AUTOUPDATE.md
├── shell/                    # 🐚 Shell configs
│   └── sorokin.zsh-theme
├── terminal/                 # 🖥️ Terminals
│   ├── config (Ghostty)
│   └── sorokin.terminal-theme.terminal
├── raycast/                  # 🚀 Raycast launcher
│   ├── README.md
│   └── BACKUP_INSTRUCTIONS.md
├── nvim/                     # 📝 Neovim
│   ├── config/
│   └── plugins/
├── scripts/                  # 🔧 Scripts
│   ├── setup.sh
│   ├── brew_upgrade_logged.sh
│   ├── brew_upgrade_cron.sh
│   └── com.user.homebrew-autoupdate.plist
└── misc/                     # 🎹 Everything else
    └── kbd67mkiirgbv3.layout.json
```

---

## After installing

```bash
# Restart the terminal, or
source ~/.zshrc

# Check the install
brew --version
mise --version
nvim --version
git --version
node --version

# Check the aliases
alias | grep -E "(glg|gl|ter|tre)"

# Check Neovim
nvim
:LazyHealth
```

---

## Links

- [Homebrew](https://brew.sh/)
- [Oh My Zsh](https://ohmyz.sh/)
- [LazyVim](https://www.lazyvim.org/)
- [Ghostty Terminal](https://ghostty.org/)
- [Raycast](https://www.raycast.com/)
- [Monaspace Font](https://github.com/githubnext/monaspace)
- [mise (runtime manager)](https://mise.jdx.dev/)

---

## License

MIT - see [LICENSE](LICENSE).

This is a personal configuration: take it apart and lift what is useful, but
expect the defaults to be tuned for one specific machine and one person's taste.
