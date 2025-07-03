#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/sketchybar"

sid=$1
focused_sid=$2
apps=$(/etc/profiles/per-user/mate/bin/aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

if [ "$sid" = "$focused_sid" ]; then
    sketchybar --set ws.$sid drawing=on
fi

if [ "${apps}" != "" ]; then
    if [ "$sid" != "$focused_sid" ]; then
        sketchybar --set ws.$sid drawing=on
    fi
    icon_strip=" "
    while read -r app; do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<<"${apps}"
else
    icon_strip=""
    if [ "$sid" != "$focused_sid" ]; then
        sketchybar --set ws.$sid drawing=off
    fi
fi
sketchybar --set ws.$sid label="$icon_strip"
