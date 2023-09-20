#!/bin/bash

# Check for git
if ! command -v git &> /dev/null; then
    echo "git is required but it's not installed. Please install git first."
    exit 1
fi

# Set HISTIGNORE
export HISTIGNORE="$HISTIGNORE:fh*"

# Install fzf if it's not already installed
if ! command -v fzf &> /dev/null; then
    echo "fzf not found. Installing..."
    if git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; then
        ~/.fzf/install --all
    else
        echo "Failed to clone fzf. Exiting..."
        exit 1
    fi
else
    echo "fzf is already installed."
fi

# Ensure directory exists
mkdir -p ~/fzf_tool/scripts

# The path to the fzf_tools.sh script
FZF_TOOLS_PATH="$HOME/fzf_tool/scripts/fzf_tools.sh"\
SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="${SCRIPT_PATH%/.*}"
FZF_TOOLS_CURR_PATH="$SCRIPT_DIR/fzf_tools.sh"\

# Check if .bashrc already sources fzf_tools.sh
if ! grep -qxF "source $FZF_TOOLS_PATH" ~/.bashrc; then
    # Copy the fzf_tools.sh script to the scripts directory\
    cp "$FZF_TOOLS_CURR_PATH" "$FZF_TOOLS_PATH"\
    
    # If not, append the source line to .bashrc
    echo "source \"$FZF_TOOLS_PATH\"" >> ~/.bashrc
    echo "Added fzf_tools.sh to .bashrc"
else
    echo "fzf_tools.sh is already sourced in .bashrc"
fi

echo "Installation and setup complete!"
