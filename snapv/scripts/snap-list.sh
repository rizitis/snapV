#!/bin/bash

# Define ANSI escape codes for colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Function to list installed Snap packages
list_installed_packages() {
    local user_home="/home/$USER"
    local snap_dir="$user_home/.local/bin/snapv/snaps"
    if [ -d "$snap_dir" ]; then
        # Print header for installed packages in green color
        echo -e "${GREEN}Installed Snap packages:${NC}"
        # List directories in $snap_dir excluding disabled directory and print in green color
        find "$snap_dir"/* -maxdepth 0 -type d ! -name disabled -exec basename {} \;
    else
        echo "No Snap packages installed."
    fi
}

# Function to list disabled Snap packages
list_disabled_packages() {
    local user_home="/home/$USER"
    local disabled_dir="$user_home/.local/bin/snapv/disabled"
    if [ -d "$disabled_dir" ]; then
        # Print header for disabled packages in red color
        echo -e "${RED}Disabled Snap packages:${NC}"
        # List directories in $disabled_dir and print in red color
        find "$disabled_dir"/* -maxdepth 0 -type d -exec basename {} \; | sed -e "s/^//" -e "s/$//"
    else
        echo "No disabled Snap packages."
    fi
}

# Call functions to list installed and disabled packages
list_installed_packages
list_disabled_packages
