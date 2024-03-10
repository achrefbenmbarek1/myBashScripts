#!/usr/bin/env bash

attached_session_file="/tmp/attached_tmux_session.txt"

if [[ $# -ne 1 ]]; then
    notify-send "Usage: $0 <number>"
    exit 1
fi

input_number=$1
read_selected_session() {
    if [ -f "$attached_session_file" ]; then
        cat "$attached_session_file"
    fi
}

write_selected_session() {
    echo "$1" > "$attached_session_file"
}

stored_session=$(read_selected_session)
storedSessionName=$(basename "$stored_session" | tr . _)
idsAndWorkspacesOfWindows=$(wmctrl -l | cut -d " " -f3,1)
doesMyTerminalExist=$(echo "$idsAndWorkspacesOfWindows" | cut -d " " -f2 | grep -n "2" | cut -d ':' -f1 | head -n 1)
targetWindowId=$(echo "$idsAndWorkspacesOfWindows" | cut -d " " -f1 | head -n "$doesMyTerminalExist" | tail -n 1)
xdotool windowactivate "$targetWindowId"
sleep 1
tmux_running=$(pgrep tmux)

if [[ -z $tmux_running ]]; then
  tmux detach -s "$storedSessionName"
fi
sessions=()
mapfile -t sessions < <(tmux list-sessions -F "#S")
selected_session="${sessions[$((input_number - 1))]}"
xdotool type "tmux attach-session -t $selected_session"
xdotool key Return
write_selected_session "$selected_session"


