#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

sketchybar --add event workspace_focus

sketchybar --add item workspace_manager left \
	--set workspace_manager \
	drawing=off \
	updates=on \
	script="$PLUGIN_DIR/workspace_manager.sh"

sketchybar --subscribe workspace_manager workspace_focus