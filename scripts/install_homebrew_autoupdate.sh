#!/bin/bash

# ==============================================================================
# Homebrew Auto-Update Installer
# ==============================================================================
# This script configures and installs the launchd job for automatic Homebrew
# updates, replacing hardcoded paths with the current user's paths.
# ==============================================================================

set -e # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_PLIST="$SCRIPT_DIR/com.user.homebrew-autoupdate.plist"
INSTALL_PLIST="$HOME/Library/LaunchAgents/com.user.homebrew-autoupdate.plist"
LOG_DIR="$HOME/Library/Logs/homebrew-cron"

echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║    Homebrew Auto-Update Installer                          ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_info "This script will set up automatic daily Homebrew updates at 11:09 AM"
echo ""

# Check if template exists
if [ ! -f "$TEMPLATE_PLIST" ]; then
  print_error "Template plist not found: $TEMPLATE_PLIST"
  exit 1
fi

# Create log directory
print_step "Creating log directory"
mkdir -p "$LOG_DIR"
print_success "Log directory created: $LOG_DIR"

# Create LaunchAgents directory if it doesn't exist
print_step "Ensuring LaunchAgents directory exists"
mkdir -p "$HOME/Library/LaunchAgents"
print_success "LaunchAgents directory ready"

# Create plist with correct paths
print_step "Configuring launchd job"
print_info "Replacing paths:"
print_info "  \$HOME -> $HOME"
print_info "  \$SCRIPT_DIR -> $SCRIPT_DIR"

# Replace placeholders with actual paths in the plist
sed -e "s|\$HOME|$HOME|g" -e "s|\$SCRIPT_DIR|$SCRIPT_DIR|g" "$TEMPLATE_PLIST" >"$INSTALL_PLIST"

print_success "Configuration file created: $INSTALL_PLIST"

# Unload existing job if present
print_step "Checking for existing launchd job"
if launchctl list | grep -q "com.user.homebrew-autoupdate"; then
  print_info "Unloading existing job..."
  launchctl unload "$INSTALL_PLIST" 2>/dev/null || true
  print_success "Existing job unloaded"
fi

# Load the job
print_step "Loading launchd job"
launchctl load "$INSTALL_PLIST"
print_success "Launchd job loaded successfully"

# Show status
print_step "Installation Complete!"
echo ""
print_success "Automatic Homebrew updates configured"
echo ""
print_info "Schedule: Daily at 11:09 AM"
print_info "Script: $SCRIPT_DIR/brew_upgrade_cron.sh"
print_info "Logs: $LOG_DIR/brew-update-YYYY-MM-DD.log"
echo ""
print_info "Management commands:"
echo "  launchctl start com.user.homebrew-autoupdate   # Run now"
echo "  launchctl stop com.user.homebrew-autoupdate    # Stop"
echo "  launchctl unload $INSTALL_PLIST  # Disable"
echo "  tail -f $LOG_DIR/brew-update-\$(date +%Y-%m-%d).log  # View logs"
echo ""
print_warning "To test the setup, run:"
echo "  $SCRIPT_DIR/brew_upgrade_cron.sh"
