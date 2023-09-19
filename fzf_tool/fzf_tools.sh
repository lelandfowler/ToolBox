#!/bin/bash

# Define the fzf interactive function
fzf_interactive() {
    [ -n "$READLINE_LINE" ] && local QUERY="-q $READLINE_LINE" || local QUERY=""
    local COMMAND=$(history | awk '{$1=""; print substr($0, 2)}' | awk '!x[$0]++' | fzf $QUERY --tac --height 10%)
    READLINE_LINE=$COMMAND
    READLINE_POINT=${#COMMAND}

    # Update the history ignore pattern to ignore commands starting with 'fh'
    export HISTIGNORE="$HISTIGNORE:fh*"
}

# Bind the Ctrl+f key and Ctrl+Alt+f to the fzf interactive function
bind -x '"\C-f": fzf_interactive'
bind -x '"\e\C-f": fzf_interactive'



# Define the fh function
fh() {
    local LINES=$1
    local QUERY=""

    # Default
    if [ -z "$1" ]; then
        LINES=5
    elif ! [[ $LINES =~ ^[0-9]+$ ]]; then
        LINES=5
    fi

    # User selects a command, and we get the command number and the command
    local SELECTED=$(history | fzf $QUERY --tac --height 40%)
    local CMD_NUM=$(echo "$SELECTED" | awk '{print $1}')
    local CMD=$(echo "$SELECTED" | awk '{$1=""; print substr($0, 2)}')

    # Display the lines around the selected command
    echo "______________________________________________"
    history | grep -E -B$LINES -A$LINES "^[ ]+$CMD_NUM "
    echo "______________________________________________"

    # Update the history ignore pattern to ignore commands starting with 'fh'
    export HISTIGNORE="$HISTIGNORE:fh*"
}