#!/usr/bin/env bash

attached_session_file=/tmp/attached_tmux_session.txt

idsAndWorkspacesOfWindows=$(wmctrl -l | cut -d " " -f3,1)
doesMyTerminalExist=$(echo "$idsAndWorkspacesOfWindows" | cut -d " " -f2 | grep -n "2" | cut -d ':' -f1 | head -n 1)
targetWindowId=$(echo "$idsAndWorkspacesOfWindows" | cut -d " " -f1 | head -n "$doesMyTerminalExist" | tail -n 1)
xdotool windowactivate "$targetWindowId"

read_attached_session() {
    if [ -f "$attached_session_file" ]; then
        cat "$attached_session_file"
    fi
}

attachedSession=$(read_attached_session)
attachedSessionName=$(basename "$attachedSession" | tr . _)

if [[ -z "$attachedSession" ]]; then 
  notify-send "you didn't attach a session through the tool"
  exit 1
fi

tmux detach -s "$attachedSession"

echo -n > "$attached_session_file"

notify-send "session deattached, over"

