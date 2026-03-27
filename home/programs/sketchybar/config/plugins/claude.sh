#!/bin/sh

CACHE_FILE="/tmp/claude_usage_cache"

# Get Claude Code OAuth token from macOS Keychain
CREDS=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
if [ -z "$CREDS" ]; then
  sketchybar --set "$NAME" label="no auth" icon.color="0xff888888"
  exit 0
fi

TOKEN=$(echo "$CREDS" | jq -r '.claudeAiOauth.accessToken' 2>/dev/null)
if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
  sketchybar --set "$NAME" label="no token" icon.color="0xff888888"
  exit 0
fi

# Fetch usage data from Anthropic API
USAGE=$(curl -s -X GET "https://api.anthropic.com/api/oauth/usage" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "anthropic-beta: oauth-2025-04-20" 2>/dev/null)

if [ -z "$USAGE" ]; then
  sketchybar --set "$NAME" label="error" icon.color="0xffff5555"
  exit 0
fi

# Check for API errors
API_ERROR=$(echo "$USAGE" | jq -r '.error.type // empty' 2>/dev/null)
if [ -n "$API_ERROR" ]; then
  case "$API_ERROR" in
    rate_limit_error)
      # Rate limited - use cached value if available
      if [ -f "$CACHE_FILE" ]; then
        CACHED=$(cat "$CACHE_FILE")
        sketchybar --set "$NAME" label="$CACHED" icon.color="0xffaaaaaa"
      else
        sketchybar --set "$NAME" label="limited" icon.color="0xffaaaaaa"
      fi
      ;;
    authentication_error)
      sketchybar --set "$NAME" label="expired" icon.color="0xffff5555"
      ;;
    *)
      sketchybar --set "$NAME" label="err" icon.color="0xffff5555"
      ;;
  esac
  exit 0
fi

# Parse the five_hour limit (more relevant for burst activity)
UTIL=$(echo "$USAGE" | jq -r '.five_hour.utilization // empty' 2>/dev/null)
RESET=$(echo "$USAGE" | jq -r '.five_hour.resets_at // empty' 2>/dev/null)
WINDOW="5h"

# Fall back to seven_day if five_hour is not available
if [ -z "$UTIL" ] || [ "$UTIL" = "null" ]; then
  UTIL=$(echo "$USAGE" | jq -r '.seven_day.utilization // empty' 2>/dev/null)
  RESET=$(echo "$USAGE" | jq -r '.seven_day.resets_at // empty' 2>/dev/null)
  WINDOW="7d"
fi

# Default to 0% if no usage data (fresh/unused state)
if [ -z "$UTIL" ] || [ "$UTIL" = "null" ]; then
  sketchybar --set "$NAME" label="0%" icon.color="0xffffffff"
  echo "0%" > "$CACHE_FILE"
  exit 0
fi

# Calculate time until reset (API returns UTC timestamps)
if [ -n "$RESET" ] && [ "$RESET" != "null" ]; then
  # Parse UTC timestamp - strip fractional seconds and timezone suffix
  RESET_DT=$(echo "$RESET" | sed 's/\.[0-9]*+00:00$//')
  # Parse as UTC (-u flag) to get correct epoch
  RESET_EPOCH=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "$RESET_DT" "+%s" 2>/dev/null)
  NOW_EPOCH=$(date "+%s")

  if [ -n "$RESET_EPOCH" ]; then
    DIFF=$((RESET_EPOCH - NOW_EPOCH))
    if [ "$DIFF" -gt 0 ]; then
      HOURS=$((DIFF / 3600))
      MINS=$(((DIFF % 3600) / 60))
      if [ "$HOURS" -gt 0 ]; then
        TIME_STR="${HOURS}h${MINS}m"
      else
        TIME_STR="${MINS}m"
      fi
    else
      TIME_STR="now"
    fi
  else
    TIME_STR=""
  fi
else
  TIME_STR=""
fi

# Format percentage (remove decimal)
PCT=$(printf "%.0f" "$UTIL")

# Set icon color based on usage level
if [ "$PCT" -ge 80 ]; then
  ICON_COLOR="0xffff5555"  # Red
elif [ "$PCT" -ge 50 ]; then
  ICON_COLOR="0xffffaa55"  # Orange
else
  ICON_COLOR="0xffffffff"  # White
fi

# Update the bar item and cache the value
if [ -n "$TIME_STR" ]; then
  LABEL="${PCT}% ${TIME_STR}"
else
  LABEL="${PCT}%"
fi

sketchybar --set "$NAME" label="$LABEL" icon.color="$ICON_COLOR"
echo "$LABEL" > "$CACHE_FILE"
