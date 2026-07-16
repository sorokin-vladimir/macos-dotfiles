#!/bin/bash

# ==============================================================================
# Raycast Configuration Backup Script
# ==============================================================================
# Creates a backup of all Raycast configuration files for manual migration
# ==============================================================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKUP_DIR="$REPO_ROOT/raycast/backup"
RAYCAST_DIR="$HOME/Library/Application Support/com.raycast.macos"
PREF_FILE="$HOME/Library/Preferences/com.raycast.macos.plist"

echo -e "${BLUE}==>${NC} ${GREEN}Raycast Configuration Backup${NC}\n"

# Check if Raycast is installed
if [ ! -d "$RAYCAST_DIR" ]; then
  echo -e "${YELLOW}Warning:${NC} Raycast directory not found: $RAYCAST_DIR"
  echo "Is Raycast installed?"
  exit 1
fi

# Create backup directory
echo -e "${BLUE}Creating backup directory...${NC}"
mkdir -p "$BACKUP_DIR"

# Backup SQLite databases
echo -e "${BLUE}Backing up databases...${NC}"
cp "$RAYCAST_DIR"/raycast-enc.sqlite* "$BACKUP_DIR/" 2>/dev/null || echo "  raycast-enc.sqlite not found"
cp "$RAYCAST_DIR"/raycast-activities-enc.sqlite* "$BACKUP_DIR/" 2>/dev/null || echo "  raycast-activities-enc.sqlite not found"
cp "$RAYCAST_DIR"/raycast-emoji.sqlite* "$BACKUP_DIR/" 2>/dev/null || echo "  raycast-emoji.sqlite not found"

# Backup NodeJS runtime
echo -e "${BLUE}Backing up NodeJS runtime...${NC}"
if [ -d "$RAYCAST_DIR/NodeJS" ]; then
  cp -R "$RAYCAST_DIR/NodeJS" "$BACKUP_DIR/" 2>/dev/null
  echo "  NodeJS copied"
else
  echo "  NodeJS directory not found (optional)"
fi

# Backup extensions (to main raycast/ directory, not backup/)
echo -e "${BLUE}Backing up extensions...${NC}"
if [ -d "$RAYCAST_DIR/extensions" ]; then
  rm -rf "$REPO_ROOT/raycast/extensions"
  cp -R "$RAYCAST_DIR/extensions" "$REPO_ROOT/raycast/"
  echo "  Extensions copied to raycast/extensions/"
else
  echo "  Extensions directory not found"
fi

# Backup plist
echo -e "${BLUE}Backing up preferences...${NC}"
if [ -f "$PREF_FILE" ]; then
  cp "$PREF_FILE" "$BACKUP_DIR/"
  echo "  com.raycast.macos.plist copied"
else
  echo "  Preferences file not found"
fi

# Show summary
echo ""
echo -e "${GREEN}✓${NC} Backup completed!"
echo ""
echo "Backup location: $BACKUP_DIR"
echo ""
echo "Files backed up:"
ls -lh "$BACKUP_DIR" 2>/dev/null | tail -n +2 | awk '{print "  " $9 " (" $5 ")"}'
echo ""
echo "Extensions backed up to: $REPO_ROOT/raycast/extensions/"
echo ""
echo -e "${YELLOW}Note:${NC} backup/ and extensions/ are in .gitignore and won't be committed."
echo "      They hold clipboard history, snippets, notes and account data."
echo "      This repo is public - move these files between machines directly."
