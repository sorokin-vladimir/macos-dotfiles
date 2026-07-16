#!/bin/bash

echo "=========================================="
echo "🍺 Homebrew Update Script"
echo "=========================================="
echo ""

echo "📦 Updating Homebrew..."
brew update
if [ $? -eq 0 ]; then
  echo "✅ Update successful"
else
  echo "❌ Update failed"
  exit 1
fi
echo ""

echo "⬆️  Checking packages to upgrade..."
echo "---"
brew outdated
echo "---"
echo ""

echo "⬆️  Upgrading packages..."
brew upgrade
if [ $? -eq 0 ]; then
  echo "✅ Upgrade successful"
else
  echo "❌ Upgrade failed"
  exit 1
fi
echo ""

echo "🧹 Cleaning up..."
brew cleanup
echo "✅ Cleanup done"
echo ""

echo "♻️  Removing unused dependencies..."
brew autoremove
echo "✅ Autoremove done"
echo ""

echo "🔍 Checking Homebrew health..."
brew doctor
echo ""

echo "=========================================="
echo "✨ All done!"
echo "=========================================="
