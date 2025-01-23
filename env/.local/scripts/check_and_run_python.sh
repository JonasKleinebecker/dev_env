#!/bin/bash

# Get the current session and window from tmux
TMUX_SESSION=$(tmux display-message -p '#S')
TMUX_WINDOW=$(tmux display-message -p '#I')

# Initialize variables
HAS_PYTHON=0
PYTHON_PANE=""

tmux_list_panes=$(tmux list-panes -t $TMUX_SESSION:$TMUX_WINDOW -F '#{pane_index} #{pane_current_command} #{pane_title}')

while IFS= read -r pane; do
    INDEX=$(echo "$pane" | awk '{print $1}')
    COMMAND=$(echo "$pane" | awk '{print $2}')
    TITLE=$(echo "$pane" | cut -d' ' -f3-)
    if [[ "$COMMAND" == "python3" ]]; then
        HAS_PYTHON=1
        PYTHON_PANE="$INDEX"
        break
    fi
done < <(tmux list-panes -t $TMUX_SESSION:$TMUX_WINDOW -F '#{pane_index} #{pane_current_command} #{pane_title}')

# If no python3 pane exists, create a new one
if [ $HAS_PYTHON -eq 0 ]; then
    tmux split-window -h -t $TMUX_SESSION:$TMUX_WINDOW
    NEW_PANE=$(tmux list-panes -t $TMUX_SESSION:$TMUX_WINDOW -F '#{pane_index}' | tail -n 1)
    tmux send-keys -t $TMUX_SESSION:$TMUX_WINDOW.$NEW_PANE "python3" C-m
    PYTHON_PANE="$NEW_PANE"
fi

echo "let g:slime_default_config = {'socket_name': 'default', 'target_pane': '${TMUX_SESSION}:${TMUX_WINDOW}.${PYTHON_PANE}'}"
