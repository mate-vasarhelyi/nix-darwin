#!/usr/bin/env bash

set -euo pipefail

# Paths
EXTENSIONS_NIX_FILE="$HOME/nix-darwin/home/programs/cursor/extensions.nix"

echo "🔧 Exporting Cursor extensions to extensions.nix..."

# Check if Cursor is available
if ! command -v cursor &> /dev/null; then
    echo "❌ Cursor not found in PATH. Make sure Cursor is installed and available."
    exit 1
fi

echo "📋 Getting list of installed extensions..."

# Get list of currently installed extensions
INSTALLED_EXTENSIONS=$(cursor --list-extensions 2>/dev/null || echo "")

if [ -z "$INSTALLED_EXTENSIONS" ]; then
    echo "⚠️  No extensions found. Make sure Cursor has extensions installed."
    echo "   Creating empty extensions list..."
    INSTALLED_EXTENSIONS=""
fi

echo "📝 Formatting extensions for Nix..."

# Create temporary file
TEMP_FILE=$(mktemp)

# Start the Nix array
echo "[" > "$TEMP_FILE"

# Add each extension as a quoted string
if [ -n "$INSTALLED_EXTENSIONS" ]; then
    echo "$INSTALLED_EXTENSIONS" | sort | while read -r ext; do
        if [ -n "$ext" ]; then
            echo "  \"$ext\"" >> "$TEMP_FILE"
        fi
    done
fi

# Close the Nix array
echo "]" >> "$TEMP_FILE"

# Backup existing extensions.nix
if [ -f "$EXTENSIONS_NIX_FILE" ]; then
    cp "$EXTENSIONS_NIX_FILE" "$EXTENSIONS_NIX_FILE.backup"
    echo "📦 Backed up existing extensions.nix to extensions.nix.backup"
fi

# Move new file into place
mv "$TEMP_FILE" "$EXTENSIONS_NIX_FILE"

# Count extensions
EXTENSION_COUNT=$(echo "$INSTALLED_EXTENSIONS" | grep -c . || echo "0")

echo "✅ Extensions exported successfully!"
echo "📁 Updated: $EXTENSIONS_NIX_FILE"
echo "📊 Found $EXTENSION_COUNT extensions"
echo ""
echo "🔄 To apply changes, run: dr (darwin-rebuild)" 