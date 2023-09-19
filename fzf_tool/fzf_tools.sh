#!/bin/bash

fzf_interactive() {
    if [ -n "$READLINE_LINE" ]; then
        local QUERY="-q $READLINE_LINE"
    else
        local QUERY=""
    fi
    local COMMAND
    COMMAND=$(history | awk '{$1=""; print substr($0, 2)}' | awk '!x[$0]++' | fzf "$QUERY" --tac --height 10%)
    READLINE_LINE=$COMMAND
    READLINE_POINT=${#COMMAND}
}


# Bind the Ctrl+f key and Ctrl+Alt+f to the fzf interactive function
bind -x '"\C-f": fzf_interactive'
bind -x '"\e\C-f": fzf_interactive'

fh() {
    local LINES=$1
    local QUERY=""

    # Default value for LINES if not provided or not a positive integer
    if [ -z "$1" ] || ! [[ $LINES =~ ^[0-9]+$ ]]; then
        LINES=5
    fi

    # User selects a command, and we get the command number and the command
    local SELECTED
    local CMD_NUM
    SELECTED=$(history | fzf "$QUERY" --tac --height 40%)
    CMD_NUM=$(echo "$SELECTED" | awk '{print $1}')

    # Display the lines around the selected command
    echo "______________________________________________"
    history | grep -E -B$LINES -A$LINES "^[ ]+$CMD_NUM "
    echo "______________________________________________"
}