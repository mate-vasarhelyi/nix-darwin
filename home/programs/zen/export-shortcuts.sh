#!/usr/bin/env bash

set -euo pipefail

# Paths
SHORTCUTS_FILE_TARGET="$HOME/nix-darwin/home/programs/zen/shortcuts.json"

echo "🔧 Exporting Zen Browser shortcuts..."

# Find the active profile directory
echo "🔍 Finding active Zen Browser profile..."

# Read profiles.ini to find the default profile
PROFILES_INI="$HOME/Library/Application Support/zen/profiles.ini"
if [ ! -f "$PROFILES_INI" ]; then
    echo "❌ Zen Browser profiles.ini not found at: $PROFILES_INI"
    echo "   Make sure Zen Browser is installed and has been run at least once."
    exit 1
fi

# Extract the default profile path
PROFILE_PATH=$(grep -A 10 "\[Install" "$PROFILES_INI" | grep "Default=" | head -1 | cut -d'=' -f2)
if [ -z "$PROFILE_PATH" ]; then
    # Fallback to Profile0 default
    PROFILE_PATH=$(grep -A 5 "\[Profile0\]" "$PROFILES_INI" | grep "Path=" | cut -d'=' -f2)
fi

if [ -z "$PROFILE_PATH" ]; then
    echo "❌ Could not determine active Zen Browser profile"
    exit 1
fi

FULL_PROFILE_PATH="$HOME/Library/Application Support/zen/$PROFILE_PATH"
SHORTCUTS_FILE="$FULL_PROFILE_PATH/zen-keyboard-shortcuts.json"

echo "📁 Using profile: $PROFILE_PATH"

# Check if shortcuts file exists
if [ ! -f "$SHORTCUTS_FILE" ]; then
    echo "❌ Zen Browser shortcuts file not found at: $SHORTCUTS_FILE"
    echo "   Make sure Zen Browser has been configured with shortcuts."
    exit 1
fi

echo "📋 Copying shortcuts file..."

# Backup existing shortcuts.json
if [ -f "$SHORTCUTS_FILE_TARGET" ]; then
    cp "$SHORTCUTS_FILE_TARGET" "$SHORTCUTS_FILE_TARGET.backup"
    echo "📦 Backed up existing shortcuts.json to shortcuts.json.backup"
fi

# Copy the file directly
cp "$SHORTCUTS_FILE" "$SHORTCUTS_FILE_TARGET"

echo "✅ Shortcuts exported successfully!"
echo "📁 Updated: $SHORTCUTS_FILE_TARGET"
echo ""
echo "🔄 To apply changes, run: darwin-rebuild switch --flake .#mates-macbook" 