#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

if [ -z "$FOCUSED" ]; then
    FOCUSED=$(/etc/profiles/per-user/mate/bin/aerospace list-workspaces --focused --format "%{workspace}")
fi

if [ -n "$PREV_FOCUSED" ]; then
    if /etc/profiles/per-user/mate/bin/aerospace list-workspaces --monitor focused --empty --format "%{workspace}" | grep -q "$PREV_FOCUSED"; then
        sketchybar --remove "ws.$PREV_FOCUSED" 2>/dev/null || true
    else
        sketchybar --set "ws.$PREV_FOCUSED" label.color="$WHITE" background.border_color="$WHITE"
    fi
fi

if ! sketchybar --query "ws.$FOCUSED" >/dev/null 2>&1; then
    sketchybar --add item "ws.$FOCUSED" left \
        --set "ws.$FOCUSED" \
        label="$FOCUSED" \
        icon.drawing=off \
        label.padding_left=10 \
        label.padding_right=10 \
        label.color="$CYAN" \
        background.height=26 \
        background.corner_radius="$CORNER_RADIUS" \
        background.border_width="$BORDER_WIDTH" \
        background.border_color="$CYAN" \
        background.color="$BAR_COLOR" \
        background.drawing=on \
        click_script="/bin/bash -c '/etc/profiles/per-user/mate/bin/aerospace workspace $FOCUSED'"
else
    sketchybar --set "ws.$FOCUSED" label.color="$CYAN" background.border_color="$CYAN"
fi

# Reorder workspace items based on non-empty workspaces from /etc/profiles/per-user/mate/bin/aerospace
workspace_items=()
while IFS= read -r workspace; do
    if [ -n "$workspace" ]; then
        workspace_items+=("ws.$workspace")
    fi
done < <(/etc/profiles/per-user/mate/bin/aerospace list-workspaces --monitor focused --empty no --format "%{workspace}")

if [ ${#workspace_items[@]} -gt 1 ]; then
    sketchybar --reorder "${workspace_items[@]}"
fi
