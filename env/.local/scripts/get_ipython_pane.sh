#!/bin/bash

pane_id=$(tmux list-panes -F '#{pane_id} #{pane_cmd}' | awk '/ipython$/ {print $1; exit}')

if [ -z "$pane_id" ]; then
  tmux split-window -h 'ipython'
  pane_id=$(tmux list-panes -F '#{pane_id} #{pane_cmd}' | awk '/ipython$/ {print $1}')
fi

echo "$pane_id"
