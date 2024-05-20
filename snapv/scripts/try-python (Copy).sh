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

# Navigate to the snap directory
cd "$snap_dir" || { echo "Error: Unable to navigate to directory $snap_dir"; exit 2; }

# Find the path containing 'site-packages'
#chosen_path=$(find ./ -type d -name site-packages -exec dirname {} \; | head -n 1)
chosen_path=$(find ./ -type d -name site-packages -exec dirname {} + | head -n 1)
wait
# Print the chosen path containing 'site-packages'
echo "$chosen_path"

deactivate
# Create a hack file
echo "$chosen_path" > "$snap_dir/snap_env_hack.txt"
sed -i '1!d' "$snap_dir/snap_env_hack.txt"
sed -i 's|.*/\(.*\)|\1|' "$snap_dir/snap_env_hack.txt" 

# Read the Python version from the hack file
pyvers=$(cat "$snap_dir/snap_env_hack.txt")
echo "$pyvers"
#cd $chosen_path/site-packages || exit 8
# Activate the virtual environment
if [ -n "$chosen_path" ]; then
#     python3 -m venv  --------------------------------< need fix
#     source bin/activate -----------------------------< need fix
    # If files are found, prompt the user to choose one
    if [ -n "$found_files" ]; then
        echo "Multiple files found:"
        i=1
        for file in $found_files; do
            echo "$i. $file"
            ((i++))
        done

        read -rp "Choose the correct one (enter number): " choice

        # Ensure the chosen file exists and execute it with the chosen Python version
        if [ "$choice" -le "$i" ] && [ "$choice" -gt 0 ]; then
            chosen_file=$(echo "$found_files" | sed -n "${choice}p")

            # Ensure that chosen_file is a full path and not just a filename
            if [ ! "${chosen_file:0:${#snap_dir}}" = "$snap_dir/" ]; then
                chosen_file="$snap_dir/$chosen_file"
            fi

            "$pyvers" "$chosen_file"
        else
            echo "Invalid choice. Exiting."
            exit 3
        fi
    else
        # just in case, since we are here normally not needed deactivate because everything tried has failed...
        deactivate
        exit 4
    fi
fi
