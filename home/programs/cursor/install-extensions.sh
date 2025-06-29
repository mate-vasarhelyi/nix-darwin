#!/usr/bin/env bash

set -euo pipefail

EXTENSIONS_FILE="/Users/mate/nix-darwin/home/programs/cursor/extensions.nix"

echo "🔧 Installing Cursor extensions..."

# Check if Cursor is available
if ! command -v cursor &> /dev/null; then
  echo "❌ Cursor not found in PATH. Make sure Cursor is installed and available."
  exit 1
fi

# Check if extensions.nix exists
if [ ! -f "$EXTENSIONS_FILE" ]; then
  echo "❌ Extensions file not found at: $EXTENSIONS_FILE"
  exit 1
fi

# Get list of currently installed extensions
echo "📋 Checking currently installed extensions..."
INSTALLED_EXTENSIONS=$(cursor --list-extensions 2>/dev/null || echo "")

# Function to check if an extension is installed
is_extension_installed() {
  local ext="$1"
  echo "$INSTALLED_EXTENSIONS" | grep -q "^$ext$"
}

# Read extensions from the Nix file and convert to bash array
echo "📝 Reading extensions from $EXTENSIONS_FILE..."
# Extract extensions from the Nix array format
EXTENSIONS_TO_CHECK=($(sed -n 's/.*"\([^"]*\)".*/\1/p' "$EXTENSIONS_FILE"))

# Check which extensions need to be installed
EXTENSIONS_TO_INSTALL=()
for ext in "${EXTENSIONS_TO_CHECK[@]}"; do
  if ! is_extension_installed "$ext"; then
    EXTENSIONS_TO_INSTALL+=("$ext")
  fi
done

# If no extensions need to be installed, exit early
if [ ${#EXTENSIONS_TO_INSTALL[@]} -eq 0 ]; then
  echo "✅ All extensions are already installed."
  exit 0
fi

echo "📦 Installing ${#EXTENSIONS_TO_INSTALL[@]} missing extensions..."

# Install missing extensions
for ext in "${EXTENSIONS_TO_INSTALL[@]}"; do
  echo "  📥 Installing $ext..."
  if cursor --install-extension "$ext"; then
    echo "  ✅ Installed $ext"
  else
    echo "  ❌ Failed to install $ext"
  fi
done

echo "🎉 Extension installation completed!" 