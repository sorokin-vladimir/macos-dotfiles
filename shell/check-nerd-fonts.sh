#!/bin/bash

# ==============================================================================
# Nerd Fonts Support Checker
# ==============================================================================
# This script checks if your terminal supports Nerd Fonts icons
# ==============================================================================

echo "🔍 Checking Nerd Fonts support..."
echo ""
echo "You should see various icons below:"
echo ""

# Test basic Nerd Fonts glyphs
echo "📁 Folder icon:   "
echo "🌿 Git icon:       "
echo "⚡ Lightning:      "
echo "🚀 Rocket:         "
echo "📦 Package:        "
echo "⏰ Clock:          "
echo "📅 Calendar:       "
echo ""

echo "Git status icons:"
echo " Staged"
echo " Modified"
echo " Untracked"
echo " Deleted"
echo "⇡ Ahead"
echo "⇣ Behind"
echo ""

# Test terminal color support
echo "Checking 256-color support:"
echo -e "\033[38;5;46m■ Neon Green (46)\033[0m"
echo -e "\033[38;5;51m■ Electric Cyan (51)\033[0m"
echo -e "\033[38;5;201m■ Neon Magenta (201)\033[0m"
echo -e "\033[38;5;39m■ Electric Blue (39)\033[0m"
echo -e "\033[38;5;208m■ Bright Orange (208)\033[0m"
echo -e "\033[38;5;196m■ Bright Red (196)\033[0m"
echo ""

# Recommendation
echo "=================================================="
echo ""
echo "❓ Can you see all icons clearly?"
echo ""
echo "✅ YES → Use sorokin.zsh-theme (Nerd Fonts)"
echo "❌ NO  → Use sorokin-unicode.zsh-theme (Unicode)"
echo ""
echo "To install Nerd Fonts:"
echo "  brew install --cask font-monaspice-nerd-font"
echo ""
echo "Or search for other Nerd Fonts:"
echo "  brew search nerd-font"
echo ""
echo "=================================================="
