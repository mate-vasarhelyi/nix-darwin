#!/usr/bin/env bash

set -euo pipefail

# Paths
SHORTCUTS_FILE_SOURCE="$HOME/nix-darwin/home/programs/zen/shortcuts.json"

echo "🔧 Importing Zen Browser shortcuts..."

# Check if source file exists
if [ ! -f "$SHORTCUTS_FILE_SOURCE" ]; then
    echo "❌ Source shortcuts file not found at: $SHORTCUTS_FILE_SOURCE"
    echo "   Run 'export-zen-shortcuts' first to create the shortcuts file."
    exit 1
fi

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
SHORTCUTS_FILE_TARGET="$FULL_PROFILE_PATH/zen-keyboard-shortcuts.json"

echo "📁 Using profile: $PROFILE_PATH"

# Create profile directory if it doesn't exist
mkdir -p "$FULL_PROFILE_PATH"

# Backup existing shortcuts file if it exists
if [ -f "$SHORTCUTS_FILE_TARGET" ]; then
    cp "$SHORTCUTS_FILE_TARGET" "$SHORTCUTS_FILE_TARGET.backup"
    echo "📦 Backed up existing shortcuts to zen-keyboard-shortcuts.json.backup"
fi

echo "📋 Copying shortcuts file to Zen Browser profile..."

# Copy the file
cp "$SHORTCUTS_FILE_SOURCE" "$SHORTCUTS_FILE_TARGET"

echo "✅ Shortcuts imported successfully!"
echo "📁 Updated: $SHORTCUTS_FILE_TARGET"
echo ""
echo "🔄 Restart Zen Browser to apply the new shortcuts." 