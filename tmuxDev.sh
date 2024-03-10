#!/usr/bin/env bash

firstPatternParentDirectory=$1
parentDirectoryFullPath=$(zoxide query "$firstPatternParentDirectory")
parentDirectory=$(basename "$parentDirectoryFullPath")
z "$parentDirectoryFullPath"
tmux new-session -d -s "$parentDirectory" -n "coding"
tmux split-window -h
tmux send-keys "source .venv/$parentDirectory/bin/activate && z src && cl && nvim ." C-m
tmux split-window -v -p 20
tmux send-keys "source .venv/$parentDirectory/bin/activate && z src && cl" C-m
tmux kill-pane -t "$parentDirectory":coding.1
tmux new-window -t "$parentDirectory":2 -n "testing" 
tmux send-keys "source .venv/$parentDirectory/bin/activate && z test && cl" C-m
tmux split-window -v -p 20
tmux send-keys "source .venv/$parentDirectory/bin/activate && z test && cl" C-m
tmux select-window -t :coding
tmux select-pane -t 1
tmux attach-session -t "$parentDirectory" 
