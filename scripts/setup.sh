#!/bin/bash

# ==============================================================================
# macOS Development Environment Setup Script
# ==============================================================================
# This script automates the installation and configuration of development tools
# and environment settings for a new macOS system.
# ==============================================================================

set -e # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Configuration flags (0 = no, 1 = yes)
SKIP_HOMEBREW=0
SKIP_APPS=0
SKIP_SHELL=0
SKIP_GIT_COMPLETION=0
SKIP_MACOS=0
INTERACTIVE=1

# Git identity offered as the prompt default when nothing is configured yet
DEFAULT_GIT_NAME="Vladimir Sorokin"
DEFAULT_GIT_EMAIL="v.sorokin@hey.com"

# ==============================================================================
# Helper Functions
# ==============================================================================

print_step() {
  echo -e "\n${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_success() {
  echo -e "${GREEN}✓${NC} $1"
}

# Returns 0 when prompting is possible. Anything piped (curl | bash) or
# --non-interactive takes documented defaults instead of blocking on read.
can_prompt() {
  [ $INTERACTIVE -eq 1 ] && [ -t 0 ]
}

# Reads a single keypress and echoes a name for it: up, down, enter, space or
# the literal character.
read_key() {
  local k rest
  IFS= read -rsn1 k 2>/dev/null || return 1
  case $k in
  '' | $'\r') printf 'enter' ;;
  ' ') printf 'space' ;;
  $'\e')
    # bash 3.2 (stock on macOS) rejects a fractional read -t, so a lone Esc
    # cannot be told apart by timing. Arrows send ESC [ A in one burst, so
    # just take the two bytes; Esc is not bound to anything as a result.
    IFS= read -rsn2 rest 2>/dev/null
    case $rest in
    '[A') printf 'up' ;;
    '[B') printf 'down' ;;
    *) printf 'other' ;;
    esac
    ;;
  *) printf '%s' "$k" ;;
  esac
}

# Single-keypress confirm. Enter takes the default.
ask_yes_no() {
  local question="$1"
  local default="${2:-y}"
  local prompt key

  if ! can_prompt; then
    [ "$default" = "y" ]
    return $?
  fi

  if [ "$default" = "y" ]; then
    prompt="[Y/n]"
  else
    prompt="[y/N]"
  fi

  while true; do
    printf "${BLUE}?${NC} %s ${DIM}%s${NC} " "$question" "$prompt"
    key=$(read_key)
    case $key in
    y | Y)
      printf "${GREEN}yes${NC}\n"
      return 0
      ;;
    n | N)
      printf "no\n"
      return 1
      ;;
    enter)
      if [ "$default" = "y" ]; then
        printf "${GREEN}yes${NC}\n"
        return 0
      fi
      printf "no\n"
      return 1
      ;;
    *) printf "\n" ;;
    esac
  done
}

# Prompts for a value and echoes it. read -p writes the prompt to stderr, so the
# result stays clean for command substitution.
ask_value() {
  local question="$1"
  local default="$2"
  local answer

  if ! can_prompt; then
    echo "$default"
    return
  fi

  read -rp "$question [$default]: " answer
  echo "${answer:-$default}"
}

# Arrow-key multi-select. Echoes the chosen items space-separated.
# Usage: ask_multi "Header" "name:1" "name:0" ...  where :1 means preselected.
# Rendering goes to stderr so the result can be captured with $(...).
ask_multi() {
  local header="$1"
  shift
  local items=() marks=() i cur=0 key n box out

  for i in "$@"; do
    items+=("${i%:*}")
    marks+=("${i##*:}")
  done
  n=${#items[@]}

  if ! can_prompt; then
    for ((i = 0; i < n; i++)); do
      [ "${marks[$i]}" = "1" ] && out="$out ${items[$i]}"
    done
    printf '%s' "${out# }"
    return
  fi

  # The list must never be taller than the window, otherwise it scrolls and the
  # cuu1 redraw below starts overwriting the wrong rows. Show a moving window.
  local rows vis top=0 picked
  rows=$(tput lines 2>/dev/null) || rows=24
  vis=$((rows - 4))
  [ $vis -lt 3 ] && vis=3
  [ $vis -gt $n ] && vis=$n

  printf "${BLUE}?${NC} %s\n" "$header" >&2
  printf "${DIM}  arrows - move, space - toggle, a - all, enter - confirm, q - skip${NC}\n" >&2
  tput civis >&2

  while true; do
    # Keep the cursor inside the window
    [ $cur -lt $top ] && top=$cur
    [ $cur -ge $((top + vis)) ] && top=$((cur - vis + 1))

    for ((i = top; i < top + vis; i++)); do
      if [ "${marks[$i]}" = "1" ]; then box="${GREEN}[x]${NC}"; else box="[ ]"; fi
      if [ $i -eq $cur ]; then
        printf "  ${GREEN}>${NC} %b %s\n" "$box" "${items[$i]}" >&2
      else
        printf "    %b %s\n" "$box" "${items[$i]}" >&2
      fi
    done

    picked=0
    for ((i = 0; i < n; i++)); do
      [ "${marks[$i]}" = "1" ] && picked=$((picked + 1))
    done
    printf "${DIM}  %d-%d of %d, %d selected${NC}\n" \
      $((top + 1)) $((top + vis)) "$n" "$picked" >&2

    key=$(read_key)
    case $key in
    up) [ $cur -gt 0 ] && cur=$((cur - 1)) ;;
    down) [ $cur -lt $((n - 1)) ] && cur=$((cur + 1)) ;;
    space)
      if [ "${marks[$cur]}" = "1" ]; then marks[$cur]=0; else marks[$cur]=1; fi
      ;;
    a | A) for ((i = 0; i < n; i++)); do marks[$i]=1; done ;;
    enter) break ;;
    q | Q)
      tput cnorm >&2
      return 1
      ;;
    esac

    # Redraw in place: vis item rows plus the counter row
    for ((i = 0; i <= vis; i++)); do
      tput cuu1 >&2
      tput el >&2
    done
  done

  tput cnorm >&2
  for ((i = 0; i < n; i++)); do
    [ "${marks[$i]}" = "1" ] && out="$out ${items[$i]}"
  done
  printf '%s' "${out# }"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ==============================================================================
# Installation Functions
# ==============================================================================

install_xcode_clt() {
  print_step "Checking Xcode Command Line Tools"

  if xcode-select -p >/dev/null 2>&1; then
    print_success "Command Line Tools already installed"
    return
  fi

  # The Homebrew installer is supposed to handle this, but on a clean system
  # it did not, so install explicitly before anything needs a compiler or git
  print_info "Installing Command Line Tools, confirm the system dialog..."
  xcode-select --install >/dev/null 2>&1 || true

  # The installer runs as a separate GUI process; wait for it to finish
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done

  print_success "Command Line Tools installed"
}

install_homebrew() {
  if [ $SKIP_HOMEBREW -eq 1 ]; then
    print_info "Skipping Homebrew installation"
    return
  fi

  print_step "Installing Homebrew"

  if command_exists brew; then
    print_success "Homebrew already installed"
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs
  if [[ $(uname -m) == 'arm64' ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  print_success "Homebrew installed"
}

install_homebrew_packages() {
  if [ $SKIP_APPS -eq 1 ]; then
    print_info "Skipping Homebrew packages installation"
    return
  fi

  print_step "Installing Homebrew packages"

  brew update

  # Install CLI tools
  print_info "Installing CLI tools..."
  # git shadows the older Apple one because .zshrc already puts
  # /opt/homebrew/bin first. curl is keg-only and needs its own PATH entry,
  # which .zshrc also adds.
  brew install mise thefuck gnupg git tlrc translate-shell neovim \
    zsh-autosuggestions zsh-syntax-highlighting fd fzf ripgrep \
    lazygit lazysql ec gitlogue curl yazi ast-grep bat btop ncdu tokei gh glow \
    golangci-lint goreleaser unar pnpm lla tele

  # Since Homebrew 6 third-party taps must be trusted before anything loads
  # them, and `brew tap` loads every formula right after cloning to validate
  # the tap. Trusting afterwards is too late: the tap fails with
  # "invalid syntax in tap!". So trust first, then tap.

  # tele-beta lives in the custom tap (stable tele comes from homebrew-core)
  brew trust --tap sorokin-vladimir/tap
  brew tap sorokin-vladimir/tap
  brew install tele-beta

  # weathr lives in its own tap, not in homebrew-core
  brew trust --tap veirt/veirt
  brew tap veirt/veirt
  brew install weathr

  # lsoff lives in its own tap, not in homebrew-core
  brew trust --tap yutat23/tap
  brew tap yutat23/tap
  brew install lsoff

  echo ""
  # Install Claude Code CLI (terminal-based AI coding assistant)
  if ask_yes_no "Install Claude Code CLI (native install)?"; then
    print_info "Installing Claude Code CLI..."
    curl -fsSL https://claude.ai/install.sh | bash
    print_success "Claude Code CLI installed to ~/.local/bin/claude"
    print_info "Run 'claude auth login' to authenticate"
  fi

  echo ""
  # Install fonts (required for terminal theme)
  if ask_yes_no "Install Nerd Fonts (required for custom zsh theme)?"; then
    print_info "Installing Nerd Fonts..."
    brew install --cask font-monaspice-nerd-font
    print_success "Monaspace Nerd Font installed"
    print_info "Ghostty config uses it: font-family = \"MonaspiceNe Nerd Font Mono\", font-style = Light"
  fi

  echo ""
  # Casks are picked individually; the ":1"/":0" suffix is the default state,
  # which is also what --non-interactive installs.
  # The || true matters: q returns 1 from ask_multi and set -e would kill
  # the whole script on the assignment
  local casks
  casks=$(ask_multi "Select GUI applications to install:" \
    "ghostty:1" "claude:1" "raycast:1" "zed:1" \
    "keepassxc:1" "hey-desktop:1" "spotify:1" "telegram:1" "vlc:1" \
    "firefox:1" "zen:1" "ungoogled-chromium:1" \
    "dbeaver-community:1" "bruno:1" "orbstack:1" \
    "logseq:1" "simplenote:1" "anki:1" \
    "neohtop:1" "claude-usage-tracker:1" \
    "discord:0" "transmission:0" "tunnelblick:0" "zoom:0") || true

  if [ -n "$casks" ]; then
    print_info "Installing GUI applications..."
    # The tracker lives in a third-party tap; only tap when it was picked
    case " $casks " in
    *" claude-usage-tracker "*)
      # Trust before tapping, see the note above the formula taps
      brew trust --tap hamed-elfayome/claude-usage
      brew tap hamed-elfayome/claude-usage
      ;;
    esac
    # Word splitting is intentional: $casks is a space-separated cask list
    brew install --cask $casks
  else
    print_info "No GUI applications selected"
  fi

  print_success "Homebrew packages installed"
}

install_ohmyzsh() {
  if [ $SKIP_SHELL -eq 1 ]; then
    print_info "Skipping Oh My Zsh installation"
    return
  fi

  print_step "Installing Oh My Zsh"

  if [ -d "$HOME/.oh-my-zsh" ]; then
    print_success "Oh My Zsh already installed"
    return
  fi

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  print_success "Oh My Zsh installed"
}

copy_config_files() {
  print_step "Copying configuration files"

  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local repo_root="$(cd "$script_dir/.." && pwd)"

  # Backup existing .zshrc if it exists
  if [ -f "$HOME/.zshrc" ]; then
    print_warning "Backing up existing .zshrc to .zshrc.backup"
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
  fi

  # Copy .zshrc (from root)
  print_info "Copying .zshrc..."
  cp "$repo_root/.zshrc" "$HOME/.zshrc"

  # Copy custom theme (from shell/)
  print_info "Copying custom zsh theme..."
  mkdir -p "$HOME/.oh-my-zsh/custom/themes"
  cp "$repo_root/shell/sorokin.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/"

  # Copy Ghostty config (from terminal/)
  if command_exists ghostty; then
    print_info "Copying Ghostty config..."
    local ghostty_config_dir="$HOME/Library/Application Support/com.mitchellh.ghostty"
    mkdir -p "$ghostty_config_dir"
    cp "$repo_root/terminal/config" "$ghostty_config_dir/config"
  fi

  # Copy Neovim configs (from nvim/config/ and nvim/plugins/)
  if ask_yes_no "Copy Neovim configuration files?"; then
    # The repo only holds overrides; init.lua and lua/config/lazy.lua, which
    # bootstrap lazy.nvim and LazyVim, come from the starter
    if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
      print_info "Installing LazyVim starter..."
      local starter
      starter="$(mktemp -d)"
      git clone -q --depth 1 https://github.com/LazyVim/starter "$starter"
      rm -rf "$starter/.git"
      mkdir -p "$HOME/.config/nvim"
      # --ignore-existing keeps files an earlier partial run already copied.
      # Not cp -n: newer macOS makes it exit 1 on skipped files, tripping set -e
      rsync -a --ignore-existing "$starter/" "$HOME/.config/nvim/"
      rm -rf "$starter"
    fi

    print_info "Copying Neovim configs..."
    mkdir -p "$HOME/.config/nvim/lua/config"
    cp "$repo_root/nvim/config/"*.lua "$HOME/.config/nvim/lua/config/"

    mkdir -p "$HOME/.config/nvim/lua/plugins"
    cp "$repo_root/nvim/plugins/"*.lua "$HOME/.config/nvim/lua/plugins/"

    cp "$repo_root/nvim/lazyvim.json" "$HOME/.config/nvim/lazyvim.json"
  fi

  print_success "Configuration files copied"
}

setup_git() {
  print_step "Setting up Git"

  local current_name current_email name email
  current_name="$(git config --global user.name 2>/dev/null || true)"
  current_email="$(git config --global user.email 2>/dev/null || true)"

  if [ -n "$current_name" ] && [ -n "$current_email" ]; then
    print_info "Current: $current_name <$current_email>"
  fi

  # Keep whatever is already configured; fall back to the repo owner's identity
  # only on a machine where Git has never been set up
  name="${current_name:-$DEFAULT_GIT_NAME}"
  email="${current_email:-$DEFAULT_GIT_EMAIL}"

  if [ $INTERACTIVE -eq 1 ]; then
    print_info "Press Enter to keep the default"
    name="$(ask_value "Git user name" "$name")"
    email="$(ask_value "Git user email" "$email")"
  elif [ -z "$current_name" ] || [ -z "$current_email" ]; then
    print_warning "Non-interactive mode: falling back to $name <$email>"
    print_warning "Run without --non-interactive, or fix it with: git config --global user.email you@example.com"
  fi

  git config --global user.name "$name"
  git config --global user.email "$email"
  print_success "Git user configured: $name <$email>"

  # Set up git editor
  print_info "Setting up nvim as default Git editor..."
  git config --global core.editor "nvim"

  # Set up git alias for force push
  print_info "Setting up git alias 'please' for force-with-lease..."
  git config --global alias.please 'push --force-with-lease'

  print_success "Git configured"
}

install_git_completion() {
  if [ $SKIP_GIT_COMPLETION -eq 1 ]; then
    print_info "Skipping Git completion installation"
    return
  fi

  print_step "Installing Git completion"

  mkdir -p "$HOME/.zsh"
  cd "$HOME/.zsh"

  curl -o git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  curl -o _git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

  # Remove old completion cache
  rm -f "$HOME/.zcompdump"

  print_success "Git completion installed"
}

setup_mise() {
  print_step "Setting up mise"

  if ! command_exists mise; then
    print_error "mise not found. Please install it first."
    return 1
  fi

  # Install Node.js
  if ask_yes_no "Install Node.js 24 via mise?"; then
    print_info "Installing Node.js 24..."
    mise use -g node@24
    print_success "Node.js 24 installed"

    echo ""
    if ask_yes_no "Install global npm packages (leaf markdown viewer)?"; then
      print_info "Installing global npm packages..."
      # mise is activated only in .zshrc, so this bash process never gets
      # node on PATH; mise exec runs npm from the version installed above
      mise exec node@24 -- npm install -g @rivolink/leaf
      print_success "Global npm packages installed"
    fi
  fi

  echo ""
  # Install Go
  if ask_yes_no "Install Go via mise?"; then
    print_info "Installing Go..."
    mise use -g go@latest
    print_success "Go installed"

    echo ""
    if ask_yes_no "Install Go tools via mise (sqlc, golang-migrate)?"; then
      print_info "Installing Go tools..."
      mise use -g aqua:sqlc-dev/sqlc
      mise use -g aqua:golang-migrate/migrate
      print_success "Go tools installed"
    fi
  fi

  print_success "mise configured"
}

setup_ssh() {
  print_step "Checking SSH"

  if [ -f "$HOME/.ssh/id_rsa" ] || [ -f "$HOME/.ssh/id_ed25519" ]; then
    print_success "SSH key found"
    return
  fi

  # Key generation used to live here, but cloning this repo over SSH already
  # requires a working key, so this branch is only reached when the repo
  # arrived some other way. It cannot be automated regardless: ssh-keygen
  # prompts for path and passphrase, and the public key still has to be
  # registered with GitHub by hand.
  print_warning "No SSH key found. Create one manually:"
  echo "  ssh-keygen -t ed25519 -C \"your@email\""
  echo "  ssh-add --apple-use-keychain ~/.ssh/id_ed25519"
  echo "  pbcopy < ~/.ssh/id_ed25519.pub   # then add it at github.com/settings/keys"
}

# Builds a plist dict for a symbolic hotkey: key code, virtual key, modifiers
hotkey_plist() {
  local enabled="$1" char="$2" keycode="$3" modifiers="$4"
  printf '<dict><key>enabled</key><%s/><key>value</key><dict>' "$enabled"
  printf '<key>type</key><string>standard</string><key>parameters</key><array>'
  printf '<integer>%s</integer><integer>%s</integer><integer>%s</integer>' "$char" "$keycode" "$modifiers"
  printf '</array></dict></dict>'
}

setup_macos_keyboard() {
  if [ $SKIP_MACOS -eq 1 ]; then
    print_info "Skipping macOS keyboard settings"
    return
  fi

  print_step "Configuring keyboard layouts and shortcuts"

  if ! ask_yes_no "Set ABC + Russian - PC layouts and Cmd+Space for switching (Spotlight off)?"; then
    return
  fi

  # Russian - PC (RussianWin) keeps comma and period on the key next to right
  # Shift, instead of Shift+6 / Shift+7 as in the Mac Russian layout
  print_info "Setting input sources: ABC, Russian - PC..."
  defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
    '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>252</integer><key>KeyboardLayout Name</key><string>ABC</string></dict>' \
    '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>19458</integer><key>KeyboardLayout Name</key><string>RussianWin</string></dict>' \
    '<dict><key>Bundle ID</key><string>com.apple.CharacterPaletteIM</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>' \
    '<dict><key>Bundle ID</key><string>com.apple.PressAndHold</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>'

  # Symbolic hotkey IDs: 60 previous input source, 61 next input source,
  # 64 Spotlight search, 65 Finder search window.
  # Space is char 32 / key code 49. Modifiers: Cmd 1048576, Ctrl+Opt 786432,
  # Ctrl 262144, Cmd+Opt 1572864.
  # Spotlight goes off so Cmd+Space can switch layouts and Raycast can take
  # Ctrl+Space.
  print_info "Setting shortcuts: Cmd+Space switches layouts, Spotlight disabled..."
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add \
    60 "$(hotkey_plist true 32 49 1048576)" \
    61 "$(hotkey_plist true 32 49 786432)" \
    64 "$(hotkey_plist false 32 49 262144)" \
    65 "$(hotkey_plist false 32 49 1572864)"

  # Apply shortcut changes without logging out
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true

  print_success "Keyboard configured"
  print_warning "Input source changes fully apply after logging out and back in"
}

# ==============================================================================
# Main Setup Flow
# ==============================================================================

main() {
  echo -e "${GREEN}"
  echo "╔════════════════════════════════════════════════════════════╗"
  echo "║                                                            ║"
  echo "║    macOS Development Environment Setup Script              ║"
  echo "║                                                            ║"
  echo "╚════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"

  # Check if running on macOS
  if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only"
    exit 1
  fi

  print_info "This script will set up your development environment"
  print_info "You can skip steps or run non-interactively with flags"
  echo ""

  if [ $INTERACTIVE -eq 1 ]; then
    if ! ask_yes_no "Continue with installation?"; then
      print_info "Installation cancelled"
      exit 0
    fi
  fi

  # Run installation steps
  install_xcode_clt
  install_homebrew
  install_homebrew_packages
  install_ohmyzsh
  copy_config_files
  setup_git
  install_git_completion
  setup_mise
  setup_ssh
  setup_macos_keyboard

  # Final steps
  print_step "Setup Complete!"
  echo ""
  print_success "Your development environment has been configured"
  echo ""
  print_warning "Important next steps:"
  echo "  1. Restart your terminal or run: source ~/.zshrc"
  echo "  2. If you installed Nerd Fonts, verify icons work: echo -e \"\\ue0a0 \\uf09b \\uf07c\""
  echo "  3. Configure GPG for git signing if needed (optional)"
  echo "  4. If installed Claude Code CLI, authenticate: claude auth login"
  echo ""
  print_warning "Raycast setup (if installed):"
  echo "  1. Spotlight shortcut is disabled by the keyboard step (if you skipped it,"
  echo "     turn it off in System Settings > Keyboard > Keyboard Shortcuts)"
  echo "  2. Open Raycast and set Ctrl+Space as hotkey"
  echo "  3. Sign in to Raycast account for sync"
  echo "  4. Install extensions: Spotify Player, Google Translate"
  echo "  See raycast/README.md for detailed instructions"
  echo ""
  print_info "Additional manual steps (optional):"
  echo "  • If theme icons don't work, check Ghostty font config"
  echo "  • Claude Code CLI includes auto-updates by default"
  echo "  • See docs/SETUP.md for detailed post-installation instructions"
  echo ""
  print_info "Verify installation:"
  echo "  brew --version    # Check Homebrew"
  echo "  mise --version    # Check mise"
  echo "  nvim --version    # Check Neovim"
  echo "  node --version    # Check Node.js (if installed)"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  --skip-homebrew)
    SKIP_HOMEBREW=1
    shift
    ;;
  --skip-apps)
    SKIP_APPS=1
    shift
    ;;
  --skip-shell)
    SKIP_SHELL=1
    shift
    ;;
  --skip-git-completion)
    SKIP_GIT_COMPLETION=1
    shift
    ;;
  --skip-macos)
    SKIP_MACOS=1
    shift
    ;;
  --non-interactive)
    INTERACTIVE=0
    shift
    ;;
  -h | --help)
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --skip-homebrew          Skip Homebrew installation"
    echo "  --skip-apps              Skip application installation"
    echo "  --skip-shell             Skip shell setup (Oh My Zsh)"
    echo "  --skip-git-completion    Skip Git completion setup"
    echo "  --skip-macos             Skip keyboard layouts and shortcuts"
    echo "  --non-interactive        Run without prompts (use defaults)"
    echo "  -h, --help               Show this help message"
    exit 0
    ;;
  *)
    print_error "Unknown option: $1"
    echo "Use --help for usage information"
    exit 1
    ;;
  esac
done

# Run main setup
main
