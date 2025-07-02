#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/sketchybar"

sid=$1
apps=$(/etc/profiles/per-user/mate/bin/aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

if [ "${apps}" != "" ]; then
    sketchybar --set ws.$sid drawing=on
    icon_strip=" "
    while read -r app; do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<<"${apps}"
else
    icon_strip=""
    sketchybar --set ws.$sid drawing=off
fi
sketchybar --set ws.$sid label="$icon_strip"
