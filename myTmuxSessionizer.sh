#!/usr/bin/env bash

selected=()
bookmark_file=~/.my_tmux_bookmarks
mapfile -t selected < <(find ~/Document/projects/axeFinance ~/Document/projects/sideProjects  ~/Document/projects/personal -mindepth 1 -maxdepth 1 -type d | rofi -dmenu -multi-select -p "Select a project:")

if [[ -z "${selected[@]}" ]]; then
    notify-send "no sessions selected"
    exit 0
fi

choice=$(echo -e "Create\nBookmark" | rofi -dmenu -p "Choose action:")
if [[ "$choice" == "Bookmark" ]]; then
    printf "%s\n" "${selected[@]}" >> "$bookmark_file"
    notify-send "sessions bookmarked, over"
    exit 0
fi

for session in "${selected[@]}"; do
    echo "$session"
    selected_name=$(basename "$session" | tr . _)
    tmux new-session -ds $selected_name -c $session \; split-window -v -l 20% -c $session
    notify-send "sessions created, over"
done

