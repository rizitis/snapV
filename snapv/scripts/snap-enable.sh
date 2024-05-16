#!/bin/bash

# Check if the package name is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <package>"
    exit 1
fi

package="$1"

# Determine the directory associated with the Snap package
disabled_dir="/home/$USER/.local/bin/snapv/disabled/$package"

# Check if the directory exists
if [ ! -d "$disabled_dir" ]; then
    # Check if the package is in the enabled directory
    enabled_dir="/home/$USER/.local/bin/snapv/snaps/$package"
    if [ -d "$enableb_dir" ]; then
        echo "$package is already enabled"
        exit 0
    else        
        echo "Snap $package not found"
    fi
fi

if [ -d "$disabled_dir" ]; then
    mv /home/$USER/.local/bin/snapv/disabled/"$package" /home/$USER/.local/bin/snapv/snaps/
    echo "$package enabled"
fi 
