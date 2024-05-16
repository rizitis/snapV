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
        echo "$package is disabled"
        exit 0
    else
        echo "Error: Snap package directory $snap_dir not found"
        exit 2
    fi
fi

# Find the binary associated with the Snap package
binary=$(find "$snap_dir" -type f -executable -name "$package")

# Check if the binary exists
if [ -z "$binary" ]; then
    echo "Error: Binary for Snap package $package not found"
    exit 3
fi


# Run the binary with nohup
 "$binary" &

