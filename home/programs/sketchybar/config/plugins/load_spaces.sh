# NOT IN USE
for sid in $(/etc/profiles/per-user/mate/bin/aerospace list-workspaces --monitor 1 --empty no); do
    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        background.color=0x44ffffff \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=off \
        label="$sid" \
        click_script="/etc/profiles/per-user/mate/bin/aerospace workspace $sid" \
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"
done