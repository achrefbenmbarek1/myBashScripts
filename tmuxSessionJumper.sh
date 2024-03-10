#!/bin/bash

sessions=$(tmux list-sessions -F "#S")

selected_session=$(echo "$sessions" | rofi -dmenu -p "Select or switch to session:")
attached_session_file="/tmp/attached_tmux_session.txt"
selectedSessionName=$(basename "$selected_session" | tr . _)

read_selected_session() {
    if [ -f "$attached_session_file" ]; then
        cat "$attached_session_file"
    fi
}

write_selected_session() {
    echo "$1" > "$attached_session_file"
}

if [[ -z "$selected_session" ]];then 
  notify-send "you didn't select a session, do you copy? Over."
  exit 0
fi

choice=$(echo -e "CloseSession\nAttach" | rofi -dmenu -p "Choose action:")
if [[ "$choice" == "CloseSession" ]]; then
    potentialCurrentSession=$(read_selected_session)
    if [[ "$potentialCurrentSession"=="$selected_session" ]]; then
      echo -n > "$attached_session_file"
    fi
    tmux kill-session -t "$selectedSessionName"
    notify-send "selected session removed do you copy? Over."
    exit 0
fi


stored_session=$(read_selected_session)
stored_session_name=$(basename "$stored_session" | tr . _)
idsAndWorkspacesOfWindows=$(wmctrl -l | cut -d " " -f3,1)
doesMyTerminalExist=$(echo "$idsAndWorkspacesOfWindows" | cut -d " " -f2 | grep -n "2" | cut -d ':' -f1 | head -n 1)

if [[ -z "$doesMyTerminalExist" ]];then 
  wmctrl -s 2
  sleep 0.8
  kitty -e --hold sh -c "tmux attach-session -t $selectedSessionName"
else
  targetWindowId=$(echo "$idsAndWorkspacesOfWindows" | cut -d " " -f1 | head -n "$doesMyTerminalExist" | tail -n 1)
  xdotool windowactivate "$targetWindowId"

  if [ -n "$stored_session" ]; then
    tmux detach -s "$stored_session_name"
    sleep 0.5
  fi
    xdotool type "tmux attach-session -t $selectedSessionName"
    xdotool key Return
fi
write_selected_session "$selected_session"

notify-send "session started do you copy? Over."

