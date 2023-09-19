#!/bin/bash

# Install fzf if it's not already installed
if ! command -v fzf &> /dev/null; then
    echo "fzf not found. Installing..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
else
    echo "fzf is already installed."
fi

# The path to the fzf_tools.sh script (adjust this if necessary)
FZF_TOOLS_PATH="/path/to/your/script/fzf_tools.sh"

# Check if .bashrc already sources fzf_tools.sh
grep -qxF "source $FZF_TOOLS_PATH" ~/.bashrc
if [ $? -ne 0 ]; then
    # If not, append the source line to .bashrc
    echo "source $FZF_TOOLS_PATH" >> ~/.bashrc
    echo "Added fzf_tools.sh to .bashrc"
else
    echo "fzf_tools.sh is already sourced in .bashrc"
fi

echo "Installation and setup complete!"