#!/usr/bin/env bash

set -euo pipefail

# Paths
USER_JS_TARGET="$HOME/nix-darwin/home/programs/zen/user.js"

echo "🔧 Exporting Zen Browser user preferences..."

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
PREFS_FILE="$FULL_PROFILE_PATH/prefs.js"
USER_JS_FILE="$FULL_PROFILE_PATH/user.js"

echo "📁 Using profile: $PROFILE_PATH"

# Check if prefs file exists
if [ ! -f "$PREFS_FILE" ]; then
    echo "❌ Zen Browser prefs file not found at: $PREFS_FILE"
    echo "   Make sure Zen Browser has been run at least once."
    exit 1
fi

echo "📋 Merging preferences from prefs.js and user.js..."

# Create temporary file for processing
TEMP_FILE=$(mktemp)

# Write header
cat > "$TEMP_FILE" << 'EOF'
// Zen Browser User Preferences
// This file contains merged preferences from prefs.js and user.js
// Edit this file to customize your Zen Browser settings

EOF

# Function to extract and format preferences
extract_prefs() {
    local file="$1"
    local comment="$2"
    
    if [ -f "$file" ]; then
        echo "// $comment" >> "$TEMP_FILE"
        grep '^user_pref(' "$file" >> "$TEMP_FILE" 2>/dev/null || true
        echo "" >> "$TEMP_FILE"
    fi
}

# Extract from existing user.js first (these are intentional user settings)
extract_prefs "$USER_JS_FILE" "User-defined preferences from user.js"

# Extract from prefs.js, but filter out some auto-generated ones
if [ -f "$PREFS_FILE" ]; then
    echo "// Additional preferences from prefs.js (filtered)" >> "$TEMP_FILE"
    grep '^user_pref(' "$PREFS_FILE" | \
    grep -v -E '(lastUpdateTime|cachedClientID|normandy|telemetry|.lastCheck|.lastSync|build|startup|session)' | \
    sort -u >> "$TEMP_FILE" 2>/dev/null || true
fi

# Backup existing user.js target
if [ -f "$USER_JS_TARGET" ]; then
    cp "$USER_JS_TARGET" "$USER_JS_TARGET.backup"
    echo "📦 Backed up existing user.js to user.js.backup"
fi

# Move new file into place
mv "$TEMP_FILE" "$USER_JS_TARGET"

echo "✅ User preferences exported successfully!"
echo "📁 Updated: $USER_JS_TARGET"
echo ""
echo "💡 Note: This exports to user.js (the correct file for user preferences)"
echo "🔄 To apply changes, run: darwin-rebuild switch --flake .#mates-macbook" 