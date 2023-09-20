fzf_interactive() {
  [ -n "$READLINE_LINE" ] && local QUERY="-q $READLINE_LINE" || local QUERY=""
  local COMMAND=$(history | awk '{$1=""; print substr($0, 2)}' | awk '!x[$0]++' | fzf $QUERY --tac --height 10%)
  READLINE_LINE=$COMMAND
  READLINE_POINT=${#COMMAND}
}

bind -x '"\C-f": fzf_interactive'

export HISTIGNORE="$HISTIGNORE:fh*"

fh() {
  local LINES=$1
  local QUERY=""
  
  # If no arguments were provided, LINES is set to 0
  if [ -z "$1" ]; then
    LINES=5
  fi

  # User selects a command, and we get the command number and the command
  local SELECTED=$(history | fzf $QUERY --tac --height 40%)
  local CMD_NUM=$(echo "$SELECTED" | awk '{print $1}')
  local CMD=$(echo "$SELECTED" | awk '{$1=""; print substr($0, 2)}')

  # If LINES is not a positive integer, set it to 0
  if ! [[ $LINES =~ ^[0-9]+$ ]]; then
    LINES=5
  fi

  # Display the lines around the selected command
  echo "______________________________________________"
  history | grep -E -B$LINES -A$LINES "^[ ]+$CMD_NUM "
  echo "______________________________________________"
}

export HISTIGNORE="$HISTIGNORE:fh*"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

