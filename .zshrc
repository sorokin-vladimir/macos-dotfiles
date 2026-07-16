# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="sorokin"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi


# My conf

# ============================================
# PATH Configuration
# ============================================
# Homebrew
case ":$PATH:" in
  *":/opt/homebrew/bin:"*) ;;
  *) export PATH="/opt/homebrew/bin:$PATH" ;;
esac
case ":$PATH:" in
  *":/opt/homebrew/sbin:"*) ;;
  *) export PATH="/opt/homebrew/sbin:$PATH" ;;
esac

# curl is keg-only in Homebrew because macOS ships its own, so it needs an
# explicit entry ahead of /usr/bin to be picked up
case ":$PATH:" in
  *":/opt/homebrew/opt/curl/bin:"*) ;;
  *) export PATH="/opt/homebrew/opt/curl/bin:$PATH" ;;
esac

# Local user binaries (e.g., Claude Code CLI)
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$PATH:$HOME/.local/bin" ;;
esac

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PATH:$PNPM_HOME" ;;
esac

# ============================================
# Shell Enhancements
# ============================================
# zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

# ============================================
# Tool Initialization
# ============================================
# SSH keys
# macOS already runs an ssh-agent through launchd. Never eval "$(ssh-agent -s)"
# here: that spawned a fresh agent on every shell start and leaked the process.
# Load the key only when the agent has none; Keychain supplies the passphrase.
if ! ssh-add -l >/dev/null 2>&1; then
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
fi

# Mise (runtime version manager)
eval "$(mise activate zsh)"

# The Fuck (command correction)
eval $(thefuck --alias)

# ============================================
# Git Configuration
# ============================================
# GPG signing
export GPG_TTY=$(tty)

# Git aliases
alias glg='git log --graph --pretty=format:"%C(yellow)%h %Creset%as | %C(white)%G? %n%C(cyan)%an %C(blue)%ae%Creset%n    %s%n    %C(red)%D%n%Creset"'
alias gl='git log  --pretty=format:"%C(yellow)%h %Creset%as | %C(white)%G? %n%C(cyan)%an %C(blue)%ae%Creset%n    %s%n    %C(red)%D%n%Creset"'
alias submodule="git submodule update --init --recursive"

# ============================================
# Custom Functions
# ============================================
# Yazi file manager with directory change on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ============================================
# Aliases
# ============================================
# Navigation
alias cic="cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs"

# Useful commands
alias bupd="brew update && brew upgrade && brew cleanup"

# Development tools
alias n="nvim ."
alias lg="lazygit"

# Translation
alias ter="trans en:ru --"
alias tre="trans ru:en --"
