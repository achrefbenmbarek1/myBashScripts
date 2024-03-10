#!/bin/bash
attached_session_file="/tmp/attached_tmux_session.txt"
sessions=$(tmux list-sessions -F "#S")

for session in $sessions; do
    tmux kill-session -t "$session"
done
> "$attached_session_file"
notify-send "operation kill sessions completed successfully"

