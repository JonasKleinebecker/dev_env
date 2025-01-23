#!/bin/bash

pane_id=$(tmux list-panes -F '#{pane_id} #{pane_cmd}' | awk '/python3$/ {print $1; exit}')

if [ -z "$pane_id" ]; then
  tmux split-window -h 'python3'
  pane_id=$(tmux list-panes -F '#{pane_id} #{pane_cmd}' | awk '/python3$/ {print $1}')
fi

echo "$pane_id"
