#!/bin/bash

# Check if the package name is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <package>"
    exit 1
fi

package="$1"

# Determine the directory associated with the Snap package
snap_dir="/home/$USER/.local/bin/snapv/snaps/$package"

# Check if the directory exists
if [ ! -d "$snap_dir" ]; then
    # Check if the package is in the disabled directory
    disabled_dir="/home/$USER/.local/bin/snapv/disabled/$package"
    if [ -d "$disabled_dir" ]; then
        echo "$package is already disabled"
        exit 0
    else        
        echo "Snap $package not found"
    fi
fi

if [ -d "$snap_dir" ]; then
    mv /home/$USER/.local/bin/snapv/snaps/"$package" /home/$USER/.local/bin/snapv/disabled/
    echo "$package disabled"
fi 

