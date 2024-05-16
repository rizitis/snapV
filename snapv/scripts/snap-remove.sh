#!/bin/bash

# Check if the package name is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <package>"
    exit 1
fi

package="$1"

# Determine the directory associated with the Snap package
snap_dir="/home/$USER/.local/bin/snapv/snaps/$package"
FILES_DIRS="/home/$USER/.local/bin/snapv"
# Check if the directory exists
if [ -d "$snap_dir" ]; then
    # Remove the package from the regular directory
    rm -rf "$snap_dir"
    rm "$FILES_DIRS/{version,desc}/$package.txt"
    exit 0
fi

# Check if the package is in the disabled directory
if [ -d "/home/$USER/.local/bin/snapv/disabled/$package" ]; then
    # Remove the package from the disabled directory
    rm -rf "/home/$USER/.local/bin/snapv/disabled/$package"
    rm "$FILES_DIRS/{version,desc}/$package.txt"
else
    echo "Error: Snap package directory $snap_dir not found"
    exit 2
fi

