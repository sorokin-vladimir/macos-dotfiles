# ==============================================================================
# Sorokin ZSH Theme - Nerd Fonts Edition
# ==============================================================================
# Hybrid style: Clean design with Nerd Fonts icons and universal colors
# Colors optimized for both light and dark backgrounds
# Requires: Nerd Fonts (https://www.nerdfonts.com/)
# ==============================================================================

# Universal color palette (256-color mode, works on both light and dark themes)
local universal_green='%F{35}'    # Medium green (readable on both backgrounds)
local universal_cyan='%F{37}'     # Medium cyan (good contrast everywhere)
local universal_magenta='%F{133}' # Medium magenta (universal readability)
local universal_blue='%F{33}'     # Medium blue (works on both themes)
local universal_orange='%F{172}'  # Medium orange
local universal_red='%F{160}'     # Medium red
local universal_yellow='%F{178}'  # Medium yellow
local dim_gray='%F{243}'          # Darker gray for better readability
local reset='%f'

# ==============================================================================
# Main Prompt
# ==============================================================================

# Success/Error indicator with icons
PROMPT="%(?:${universal_green} ✓${reset} :${universal_red} ✗${reset} )"

# Directory with folder icon (compact: last 2 components)
PROMPT+="${universal_cyan}"$'\uf07c'" %2~${reset}"

# Git info
PROMPT+='$(git_prompt_info) '

# ==============================================================================
# Right Prompt
# ==============================================================================

# Git status + Time + Date with icons
RPROMPT='$(git_prompt_status)${reset} ${dim_gray}· 🕐 %T · 📅 %D{%d/%m}${reset}'

# ==============================================================================
# Git Prompt Configuration
# ==============================================================================

# Git branch with icon
ZSH_THEME_GIT_PROMPT_PREFIX=" ${universal_blue}"$'\ue0a0'" ${universal_magenta}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${reset}"

# Clean/Dirty status with icons
ZSH_THEME_GIT_PROMPT_CLEAN=" ${universal_green}"$'\uf00c'"${reset}"      # Clean repo
ZSH_THEME_GIT_PROMPT_DIRTY=" ${universal_yellow}⚡${reset}"  # Modified files

# ==============================================================================
# Detailed Git Status Icons
# ==============================================================================

# Files status
ZSH_THEME_GIT_PROMPT_ADDED="${universal_cyan}"$'\uf067'" "        # Staged files
ZSH_THEME_GIT_PROMPT_MODIFIED="${universal_yellow}⚡"    # Modified files
ZSH_THEME_GIT_PROMPT_DELETED="${universal_red}"$'\uf00d'" "        # Deleted files
ZSH_THEME_GIT_PROMPT_RENAMED="${universal_blue}"$'\uf45a'" "     # Renamed files
ZSH_THEME_GIT_PROMPT_UNTRACKED="${universal_green}"$'\uf128'" "      # Untracked files
ZSH_THEME_GIT_PROMPT_UNMERGED="${universal_red}⚠ "      # Merge conflicts

# Repository state
ZSH_THEME_GIT_PROMPT_AHEAD="${universal_magenta}⇡"         # Ahead of remote
ZSH_THEME_GIT_PROMPT_BEHIND="${universal_cyan}⇣"       # Behind remote
ZSH_THEME_GIT_PROMPT_DIVERGED="${universal_orange}⇕"     # Diverged from remote
ZSH_THEME_GIT_PROMPT_STASHED="${universal_orange}"$'\uf48b'" "      # Stashed changes

# ==============================================================================
# Example Output
# ==============================================================================
# Success:  ✓  ~/macos-dotfiles  main  · 🕐 14:32:45 · 📅 27/10
# Error:    ✗  ~/macos-dotfiles  main ⚡ ⇡1 · 🕐 14:32:45 · 📅 27/10
# Detailed: ✓  ~/macos-dotfiles  main ⚡  ⇡2 · 🕐 14:32:45 · 📅 27/10
# ==============================================================================
