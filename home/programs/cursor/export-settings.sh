#!/usr/bin/env bash

set -euo pipefail

# Paths
CURSOR_SETTINGS_FILE="$HOME/Library/Application Support/Cursor/User/settings.json"
SETTINGS_NIX_FILE="$HOME/nix-darwin/home/programs/cursor/settings.nix"

echo "🔧 Exporting Cursor settings to settings.nix..."

# Check if Cursor settings file exists
if [ ! -f "$CURSOR_SETTINGS_FILE" ]; then
    echo "❌ Cursor settings file not found at: $CURSOR_SETTINGS_FILE"
    echo "   Make sure Cursor is installed and has been run at least once."
    exit 1
fi

echo "📋 Reading current settings from Cursor..."

# Read the JSON settings and convert to Nix format
TEMP_FILE=$(mktemp)

echo "📝 Converting JSON to Nix format..."

# Use jq to convert JSON to properly formatted Nix
jq -r '
  def escape_string:
    . | gsub("\\\\"; "\\\\") | gsub("\""; "\\\"") | gsub("\\$"; "\\$");
  
  def format_value(indent):
    if type == "string" then
      "\"" + (. | escape_string) + "\""
    elif type == "array" then
      if length == 0 then "[]"
      elif (.[0] | type) == "string" then
        "[" + (map("\"" + (. | escape_string) + "\"") | join(" ")) + "]"
      else
        "[\n" + (map("    " + indent + (. | format_value(indent + "  "))) | join("\n")) + "\n" + indent + "]"
      end
    elif type == "object" then
      if (. | length) == 0 then "{}"
      else
        "{\n" + (to_entries | map("    " + indent + "\"" + (.key | escape_string) + "\" = " + (.value | format_value(indent + "  ")) + ";") | join("\n")) + "\n" + indent + "}"
      end
    elif type == "boolean" then
      if . then "true" else "false" end
    elif type == "number" then
      tostring
    else
      "\"" + (tostring | escape_string) + "\""
    end;

  "{" + "\n" + (to_entries | map("  \"" + (.key | escape_string) + "\" = " + (.value | format_value("  ")) + ";") | join("\n")) + "\n}"
' "$CURSOR_SETTINGS_FILE" > "$TEMP_FILE"

# Backup existing settings.nix
if [ -f "$SETTINGS_NIX_FILE" ]; then
    cp "$SETTINGS_NIX_FILE" "$SETTINGS_NIX_FILE.backup"
    echo "📦 Backed up existing settings.nix to settings.nix.backup"
fi

# Move new file into place
mv "$TEMP_FILE" "$SETTINGS_NIX_FILE"

echo "✅ Settings exported successfully!"
echo "📁 Updated: $SETTINGS_NIX_FILE"
echo ""
echo "🔄 To apply changes, run: darwin-rebuild switch --flake .#mates-macbook" 