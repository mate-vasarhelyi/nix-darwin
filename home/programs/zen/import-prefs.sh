#!/usr/bin/env bash

set -euo pipefail

# Paths
USER_JS_SOURCE="$HOME/nix-darwin/home/programs/zen/user.js"

echo "🔧 Importing Zen Browser user preferences..."

# Check if source file exists
if [ ! -f "$USER_JS_SOURCE" ]; then
    echo "❌ Source user.js file not found at: $USER_JS_SOURCE"
    echo "   Run 'export-zen-prefs' first to create the user.js file."
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
USER_JS_TARGET="$FULL_PROFILE_PATH/user.js"

echo "📁 Using profile: $PROFILE_PATH"

# Create profile directory if it doesn't exist
mkdir -p "$FULL_PROFILE_PATH"

# Backup existing user.js file if it exists
if [ -f "$USER_JS_TARGET" ]; then
    cp "$USER_JS_TARGET" "$USER_JS_TARGET.backup"
    echo "📦 Backed up existing user.js to user.js.backup"
fi

echo "📋 Copying user.js file to Zen Browser profile..."

# Copy the file
cp "$USER_JS_SOURCE" "$USER_JS_TARGET"

echo "✅ User preferences imported successfully!"
echo "📁 Updated: $USER_JS_TARGET"
echo ""
echo "🔄 Restart Zen Browser to apply the new preferences."
echo "💡 Note: Some preferences may require a full browser restart to take effect." 