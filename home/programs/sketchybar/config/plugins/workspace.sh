#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/sketchybar"


if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME drawing=on
  $CONFIG_DIR/plugins/update_workspace_icons.sh "$1"
  sketchybar --set $NAME background.color=0x88FF00FF label.shadow.drawing=on icon.shadow.drawing=on background.border_width=2
else
  sketchybar --set $NAME background.color=0x44FFFFFF label.shadow.drawing=off icon.shadow.drawing=off background.border_width=0
fi

if [ "$1" = "$PREV_WORKSPACE" ]; then
  $CONFIG_DIR/plugins/update_workspace_icons.sh "$1"
fi