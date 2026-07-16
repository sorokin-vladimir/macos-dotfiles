#!/bin/bash

# ==============================================================================
# Raycast Configuration Restore Script
# ==============================================================================
# Restores Raycast configuration from backup for manual migration
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKUP_DIR="$REPO_ROOT/raycast/backup"
EXTENSIONS_DIR="$REPO_ROOT/raycast/extensions"
RAYCAST_DIR="$HOME/Library/Application Support/com.raycast.macos"
PREF_FILE="$HOME/Library/Preferences/com.raycast.macos.plist"

echo -e "${BLUE}==>${NC} ${GREEN}Raycast Configuration Restore${NC}\n"

# Check if backup exists
if [ ! -d "$BACKUP_DIR" ]; then
  echo -e "${RED}Error:${NC} Backup directory not found: $BACKUP_DIR"
  echo "Run './scripts/raycast_backup.sh' first to create a backup"
  exit 1
fi

# Check if Raycast is installed
if ! command -v raycast &> /dev/null; then
  echo -e "${YELLOW}Warning:${NC} Raycast is not installed"
  echo "Install it with: brew install --cask raycast"
  exit 1
fi

# Check if this is first-time setup
if [ ! -d "$RAYCAST_DIR" ]; then
  echo -e "${YELLOW}Note:${NC} Raycast has not been launched yet"
  echo "Starting Raycast to create initial directory structure..."
  open -a Raycast
  sleep 3
  echo -e "${YELLOW}Please close Raycast completely (Cmd+Q) before continuing${NC}"
  read -p "Press Enter when Raycast is closed..."
fi

# Check if Raycast is running
if pgrep -x "Raycast" > /dev/null; then
  echo -e "${YELLOW}Warning:${NC} Raycast is currently running"
  echo "Attempting to quit Raycast..."
  killall Raycast 2>/dev/null || true
  sleep 2

  # Check again
  if pgrep -x "Raycast" > /dev/null; then
    echo -e "${RED}Error:${NC} Failed to quit Raycast"
    echo "Please quit Raycast manually (Cmd+Q) and run this script again"
    exit 1
  fi
  echo -e "${GREEN}✓${NC} Raycast closed"
fi

# Create Raycast directory if it doesn't exist
mkdir -p "$RAYCAST_DIR"

echo ""
echo -e "${BLUE}Restoring configuration...${NC}"
echo ""

# Restore databases
echo -e "${BLUE}1/5${NC} Restoring databases..."
if ls "$BACKUP_DIR"/raycast-enc.sqlite* 1> /dev/null 2>&1; then
  rm -f "$RAYCAST_DIR"/raycast-enc.sqlite*
  cp "$BACKUP_DIR"/raycast-enc.sqlite* "$RAYCAST_DIR/"
  echo -e "  ${GREEN}✓${NC} raycast-enc.sqlite restored"
else
  echo -e "  ${YELLOW}!${NC} raycast-enc.sqlite not found in backup"
fi

if ls "$BACKUP_DIR"/raycast-activities-enc.sqlite* 1> /dev/null 2>&1; then
  rm -f "$RAYCAST_DIR"/raycast-activities-enc.sqlite*
  cp "$BACKUP_DIR"/raycast-activities-enc.sqlite* "$RAYCAST_DIR/"
  echo -e "  ${GREEN}✓${NC} raycast-activities-enc.sqlite restored"
else
  echo -e "  ${YELLOW}!${NC} raycast-activities-enc.sqlite not found (optional)"
fi

if ls "$BACKUP_DIR"/raycast-emoji.sqlite* 1> /dev/null 2>&1; then
  rm -f "$RAYCAST_DIR"/raycast-emoji.sqlite*
  cp "$BACKUP_DIR"/raycast-emoji.sqlite* "$RAYCAST_DIR/"
  echo -e "  ${GREEN}✓${NC} raycast-emoji.sqlite restored"
else
  echo -e "  ${YELLOW}!${NC} raycast-emoji.sqlite not found (optional)"
fi

# Restore extensions
echo -e "\n${BLUE}2/5${NC} Restoring extensions..."
if [ -d "$EXTENSIONS_DIR" ]; then
  rm -rf "$RAYCAST_DIR/extensions"
  cp -R "$EXTENSIONS_DIR" "$RAYCAST_DIR/"
  echo -e "  ${GREEN}✓${NC} Extensions restored from raycast/extensions/"
else
  echo -e "  ${YELLOW}!${NC} Extensions directory not found"
fi

# Restore NodeJS runtime
echo -e "\n${BLUE}3/5${NC} Restoring NodeJS runtime..."
if [ -d "$BACKUP_DIR/NodeJS" ]; then
  rm -rf "$RAYCAST_DIR/NodeJS"
  cp -R "$BACKUP_DIR/NodeJS" "$RAYCAST_DIR/"
  echo -e "  ${GREEN}✓${NC} NodeJS runtime restored"
else
  echo -e "  ${YELLOW}!${NC} NodeJS runtime not found (optional)"
fi

# Restore preferences
echo -e "\n${BLUE}4/5${NC} Restoring preferences..."
if [ -f "$BACKUP_DIR/com.raycast.macos.plist" ]; then
  cp "$BACKUP_DIR/com.raycast.macos.plist" "$PREF_FILE"
  echo -e "  ${GREEN}✓${NC} Preferences restored"
else
  echo -e "  ${YELLOW}!${NC} Preferences file not found (optional)"
fi

# Set correct permissions
echo -e "\n${BLUE}5/5${NC} Setting permissions..."
chmod -R u+rw "$RAYCAST_DIR" 2>/dev/null || true
[ -f "$PREF_FILE" ] && chmod 600 "$PREF_FILE" 2>/dev/null || true
echo -e "  ${GREEN}✓${NC} Permissions set"

# Summary
echo ""
echo -e "${GREEN}✓ Restore completed!${NC}"
echo ""
echo "Configuration restored from:"
echo "  $BACKUP_DIR"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Launch Raycast: open -a Raycast"
echo "  2. Check that hotkey is set to Ctrl+Space (Cmd+,)"
echo "  3. Verify extensions are working"
echo "  4. Disable Spotlight in System Settings > Siri & Spotlight"
echo ""

# Ask if user wants to launch Raycast
read -p "Launch Raycast now? [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
  echo "Launching Raycast..."
  open -a Raycast
  echo -e "${GREEN}✓${NC} Done!"
else
  echo "You can launch Raycast manually with: open -a Raycast"
fi
