#!/bin/bash

# ==============================================================================
# Homebrew Auto-Update Script for Cron/Launchd
# ==============================================================================
# This script automatically updates Homebrew and all installed packages.
# Designed to run in the background via launchd or cron with logging and
# notifications.
# ==============================================================================

set -e # Exit on error

# Configuration
LOG_DIR="$HOME/Library/Logs/homebrew-cron"
LOG_FILE="$LOG_DIR/brew-update-$(date +%Y-%m-%d).log"
TEMP_OUTDATED="/tmp/brew-outdated-$$.txt"
TEMP_DOCTOR="/tmp/brew-doctor-$$.txt"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Helper function to send macOS notification
send_notification() {
  local title="$1"
  local message="$2"
  local sound="${3:-default}"

  osascript -e "display notification \"$message\" with title \"$title\" sound name \"$sound\""
}

# Helper function to log with timestamp
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Helper function to log without timestamp (for command output)
log_output() {
  tee -a "$LOG_FILE"
}

# Cleanup temp files on exit
cleanup() {
  rm -f "$TEMP_OUTDATED" "$TEMP_DOCTOR"
}
trap cleanup EXIT

# Start logging
{
  log "=========================================="
  log "🍺 Homebrew Auto-Update Started"
  log "=========================================="
  log ""

  # Set PATH for Homebrew (especially important for launchd)
  if [[ $(uname -m) == 'arm64' ]]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    log "📍 Apple Silicon detected - using /opt/homebrew"
  else
    export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
    log "📍 Intel Mac detected - using /usr/local"
  fi

  # Step 1: Update Homebrew
  log "📦 Updating Homebrew..."
  if brew update 2>&1 | log_output; then
    log "✅ Update successful"
  else
    log "❌ Update failed"
    send_notification "Homebrew Update Failed" "Failed to update Homebrew. Check logs at $LOG_FILE" "Basso"
    exit 1
  fi
  log ""

  # Step 2: Check outdated packages
  log "⬆️  Checking packages to upgrade..."
  brew outdated > "$TEMP_OUTDATED" 2>&1 || true

  if [ -s "$TEMP_OUTDATED" ]; then
    # File is not empty - there are outdated packages
    OUTDATED_COUNT=$(wc -l < "$TEMP_OUTDATED" | xargs)
    log "Found $OUTDATED_COUNT outdated package(s):"
    cat "$TEMP_OUTDATED" | log_output

    # Send notification about outdated packages
    if [ "$OUTDATED_COUNT" -le 5 ]; then
      # Show package names if 5 or fewer
      PACKAGE_LIST=$(cat "$TEMP_OUTDATED" | awk '{print $1}' | paste -sd ", " -)
      send_notification "Homebrew: $OUTDATED_COUNT Updates Available" "$PACKAGE_LIST"
    else
      # Just show count if more than 5
      send_notification "Homebrew: $OUTDATED_COUNT Updates Available" "Check logs for details: $LOG_FILE"
    fi
  else
    log "✅ All packages are up to date"
  fi
  log ""

  # Step 3: Upgrade packages
  log "⬆️  Upgrading packages..."
  if brew upgrade 2>&1 | log_output; then
    log "✅ Upgrade successful"
  else
    log "❌ Upgrade failed"
    send_notification "Homebrew Upgrade Failed" "Failed to upgrade packages. Check logs at $LOG_FILE" "Basso"
    exit 1
  fi
  log ""

  # Step 4: Cleanup
  log "🧹 Cleaning up..."
  if brew cleanup 2>&1 | log_output; then
    log "✅ Cleanup done"
  else
    log "❌ Cleanup failed (non-fatal)"
  fi
  log ""

  # Step 5: Autoremove unused dependencies
  log "♻️  Removing unused dependencies..."
  if brew autoremove 2>&1 | log_output; then
    log "✅ Autoremove done"
  else
    log "❌ Autoremove failed (non-fatal)"
  fi
  log ""

  # Step 6: Check Homebrew health
  log "🔍 Checking Homebrew health..."
  brew doctor > "$TEMP_DOCTOR" 2>&1 || true
  cat "$TEMP_DOCTOR" | log_output

  # Check if doctor found any issues (anything other than "ready to brew")
  if ! grep -q "Your system is ready to brew" "$TEMP_DOCTOR"; then
    log "⚠️  Homebrew doctor found issues"

    # Extract first few lines of issues for notification
    DOCTOR_ISSUES=$(head -n 3 "$TEMP_DOCTOR" | tr '\n' ' ')
    send_notification "⚠️ Homebrew Doctor Warning" "$DOCTOR_ISSUES" "Funk"
  else
    log "✅ System is ready to brew"
  fi
  log ""

  # Final success notification
  log "=========================================="
  log "✨ Homebrew Auto-Update Completed Successfully!"
  log "=========================================="

  send_notification "✅ Homebrew Updated" "All packages updated successfully" "Glass"

} 2>&1

exit 0
