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

python_version1=$(find ./ -type d -name site-packages -exec dirname {} + | head -n 1)
echo "$python_version1"
echo "$python_version1" > "$snap_dir/print_python.txt"
sed -i '1!d' "$snap_dir/print_python.txt"
sed -i 's|.*/\(.*\)|\1|' "$snap_dir/print_python.txt" 

# Read the Python version from the hack file
pyvers=$(cat "$snap_dir/print_python.txt")
echo "$pyvers"


export_env_vars() {
    # Iterate over all directories in the Snap package directory
    for dir in $(find "$snap_dir" -type d); do
        # Extract the directory name
        dir_name=$(basename "$dir")
        # Convert the directory name to uppercase and replace non-alphanumeric characters with underscores
        export_var=$(echo "${dir_name^^}" | tr -c '[:alnum:]' '_')_DIR
        # Export the environment variable
        export "$export_var=$dir"
        echo "Exporting variable: $export_var=$dir"
    done

    # Export LD_LIBRARY_PATH for common lib directories
    if [ -d "$snap_dir/lib" ]; then
        export LD_LIBRARY_PATH="$snap_dir/lib:$LD_LIBRARY_PATH"
        echo "Exporting variable: LD_LIBRARY_PATH=$snap_dir/lib:$LD_LIBRARY_PATH"
    fi
    if [ -d "$snap_dir/usr/lib" ]; then
        export LD_LIBRARY_PATH="$snap_dir/usr/lib:$LD_LIBRARY_PATH"
        echo "Exporting variable: LD_LIBRARY_PATH=$snap_dir/usr/lib:$LD_LIBRARY_PATH"
    fi

    # Export PATH for common bin directories
    if [ -d "$snap_dir/bin" ]; then
        export PATH="$snap_dir/bin:$PATH"
        echo "Exporting variable: PATH=$snap_dir/bin:$PATH"
    fi
    if [ -d "$snap_dir/usr/bin" ]; then
        export PATH="$snap_dir/usr/bin:$PATH"
        echo "Exporting variable: PATH=$snap_dir/usr/bin:$PATH"
    fi

    # Export PYTHONPATH for common python directories
    if [ -d "$snap_dir/lib/"$pyvers"/site-packages" ]; then
        export PYTHONPATH="$snap_dir/lib/"$pyvers"/site-packages:$PYTHONPATH"
        echo "Exporting variable: PYTHONPATH=$snap_dir/lib/"$pyvers"/site-packages:$PYTHONPATH"
    fi
    if [ -d "$snap_dir/usr/lib/"$pyvers"/site-packages" ]; then
        export PYTHONPATH="$snap_dir/usr/lib/"$pyvers"/site-packages:$PYTHONPATH"
        echo "Exporting variable: PYTHONPATH=$snap_dir/usr/lib/"$pyvers"/site-packages:$PYTHONPATH"
    fi

    # Export QT_PLUGIN_PATH for common Qt directories
    if [ -d "$snap_dir/lib/qt5/plugins" ]; then
        export QT_PLUGIN_PATH="$snap_dir/lib/qt5/plugins:$QT_PLUGIN_PATH"
        echo "Exporting variable: QT_PLUGIN_PATH=$snap_dir/lib/qt5/plugins:$QT_PLUGIN_PATH"
    fi
    if [ -d "$snap_dir/usr/lib/qt5/plugins" ]; then
        export QT_PLUGIN_PATH="$snap_dir/usr/lib/qt5/plugins:$QT_PLUGIN_PATH"
        echo "Exporting variable: QT_PLUGIN_PATH=$snap_dir/usr/lib/qt5/plugins:$QT_PLUGIN_PATH"
    fi

    # Export XDG_DATA_DIRS for common data directories
    if [ -d "$snap_dir/share" ]; then
        export XDG_DATA_DIRS="$snap_dir/share:$XDG_DATA_DIRS"
        echo "Exporting variable: XDG_DATA_DIRS=$snap_dir/share:$XDG_DATA_DIRS"
    fi
    if [ -d "$snap_dir/usr/share" ]; then
        export XDG_DATA_DIRS="$snap_dir/usr/share:$XDG_DATA_DIRS"
        echo "Exporting variable: XDG_DATA_DIRS=$snap_dir/usr/share:$XDG_DATA_DIRS"
    fi

    # Export XDG_CONFIG_DIRS for common config directories
    if [ -d "$snap_dir/etc/xdg" ]; then
        export XDG_CONFIG_DIRS="$snap_dir/etc/xdg:$XDG_CONFIG_DIRS"
        echo "Exporting variable: XDG_CONFIG_DIRS=$snap_dir/etc/xdg:$XDG_CONFIG_DIRS"
    fi
    if [ -d "$snap_dir/usr/etc/xdg" ]; then
        export XDG_CONFIG_DIRS="$snap_dir/usr/etc/xdg:$XDG_CONFIG_DIRS"
        echo "Exporting variable: XDG_CONFIG_DIRS=$snap_dir/usr/etc/xdg:$XDG_CONFIG_DIRS"
    fi
    
# Export FONTCONFIG_PATH for additional font directories
if [ -d "$snap_dir/etc/fonts" ]; then
    export FONTCONFIG_PATH="$snap_dir/etc/fonts:$FONTCONFIG_PATH"
    echo "Exporting variable: FONTCONFIG_PATH=$snap_dir/etc/fonts:$FONTCONFIG_PATH"
fi

# Add snap_dir/usr/share/fonts to FONTCONFIG_PATH if it exists
if [ -d "$snap_dir/usr/share/fonts" ]; then
    export FONTCONFIG_PATH="$snap_dir/usr/share/fonts:$FONTCONFIG_PATH"
    echo "Exporting variable: FONTCONFIG_PATH=$snap_dir/usr/share/fonts:$FONTCONFIG_PATH"
fi

# Export FONTCONFIG_FILE to point to the Fontconfig configuration file
if [ -f "$snap_dir/etc/fonts/fonts.conf" ]; then
    export FONTCONFIG_FILE="$snap_dir/etc/fonts/fonts.conf"
    echo "Exporting variable: FONTCONFIG_FILE=$snap_dir/etc/fonts/fonts.conf"
fi


    # Export PERLLIB for common Perl library directories
    if [ -d "$snap_dir/lib/perl5" ]; then
        export PERLLIB="$snap_dir/lib/perl5:$PERLLIB"
        echo "Exporting variable: PERLLIB=$snap_dir/lib/perl5:$PERLLIB"
    fi
    if [ -d "$snap_dir/usr/lib/perl5" ]; then
        export PERLLIB="$snap_dir/usr/lib/perl5:$PERLLIB"
        echo "Exporting variable: PERLLIB=$snap_dir/usr/lib/perl5:$PERLLIB"
    fi

    # Export MANPATH for common man directories
    if [ -d "$snap_dir/share/man" ]; then
        export MANPATH="$snap_dir/share/man:$MANPATH"
        echo "Exporting variable: MANPATH=$snap_dir/share/man:$MANPATH"
    fi
    if [ -d "$snap_dir/usr/share/man" ]; then
        export MANPATH="$snap_dir/usr/share/man:$MANPATH"
        echo "Exporting variable: MANPATH=$snap_dir/usr/share/man:$MANPATH"
    fi

    # Export INFOPATH for common info directories
    if [ -d "$snap_dir/share/info" ]; then
        export INFOPATH="$snap_dir/share/info:$INFOPATH"
        echo "Exporting variable: INFOPATH=$snap_dir/share/info:$INFOPATH"
    fi
    if [ -d "$snap_dir/usr/share/info" ]; then
        export INFOPATH="$snap_dir/usr/share/info:$INFOPATH"
        echo "Exporting variable: INFOPATH=$snap_dir/usr/share/info:$INFOPATH"
    fi

    # Export PKG_CONFIG_PATH for common pkg-config directories
    if [ -d "$snap_dir/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$snap_dir/lib/pkgconfig:$PKG_CONFIG_PATH"
        echo "Exporting variable: PKG_CONFIG_PATH=$snap_dir/lib/pkgconfig:$PKG_CONFIG_PATH"
    fi
    if [ -d "$snap_dir/usr/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$snap_dir/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
        echo "Exporting variable: PKG_CONFIG_PATH=$snap_dir/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
    fi
    if [ -d "$snap_dir/share/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$snap_dir/share/pkgconfig:$PKG_CONFIG_PATH"
        echo "Exporting variable: PKG_CONFIG_PATH=$snap_dir/share/pkgconfig:$PKG_CONFIG_PATH"
    fi
    if [ -d "$snap_dir/usr/share/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$snap_dir/usr/share/pkgconfig:$PKG_CONFIG_PATH"
        echo "Exporting variable: PKG_CONFIG_PATH=$snap_dir/usr/share/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # Export GTK paths
    if [ -d "$snap_dir/lib/gtk-2.0" ]; then
        export GTK_PATH="$snap_dir/lib/gtk-2.0:$GTK_PATH"
        echo "Exporting variable: GTK_PATH=$snap_dir/lib/gtk-2.0:$GTK_PATH"
    fi
    if [ -d "$snap_dir/usr/lib/gtk-2.0" ]; then
        export GTK_PATH="$snap_dir/usr/lib/gtk-2.0:$GTK_PATH"
        echo "Exporting variable: GTK_PATH=$snap_dir/usr/lib/gtk-2.0:$GTK_PATH"
    fi
    if [ -d "$snap_dir/lib/gtk-3.0" ]; then
        export GTK_PATH="$snap_dir/lib/gtk-3.0:$GTK_PATH"
        echo "Exporting variable: GTK_PATH=$snap_dir/lib/gtk-3.0:$GTK_PATH"
    fi
    if [ -d "$snap_dir/usr/lib/gtk-3.0" ]; then
        export GTK_PATH="$snap_dir/usr/lib/gtk-3.0:$GTK_PATH"
        echo "Exporting variable: GTK_PATH=$snap_dir/usr/lib/gtk-3.0:$GTK_PATH"
    fi
    if [ -d "$snap_dir/etc/gtk-2.0" ]; then
        export GTK2_RC_FILES="$snap_dir/etc/gtk-2.0:$GTK2_RC_FILES"
        echo "Exporting variable: GTK2_RC_FILES=$snap_dir/etc/gtk-2.0:$GTK2_RC_FILES"
    fi
    if [ -d "$snap_dir/etc/gtk-3.0" ]; then
        export GTK3_MODULES="$snap_dir/etc/gtk-3.0:$GTK3_MODULES"
        echo "Exporting variable: GTK3_MODULES=$snap_dir/etc/gtk-3.0:$GTK3_MODULES"
    fi
}

# Call the function to export environment variables
export_env_vars

# Find the file $package or $package.py in the current directory and all subdirectories
found_files=$(find . -type f \( -name "$package" -o -name "$package.py" \))

# Check if any files were found
if [[ -n "$found_files" ]]; then
  # Count the number of found files
  file_count=$(echo "$found_files" | wc -l)
  
  if [[ "$file_count" -gt 1 ]]; then
    echo "Found multiple files:"
    echo "$found_files" | nl -w 2 -s '. ' # Print files with numbers for selection

    # Ask user to choose a file
    echo "Please enter the number of the file you want to run:"
    read -r choice

    # Get the selected file path
    selected_file=$(echo "$found_files" | sed -n "${choice}p")

    # Check if the selected file is valid
    if [[ -n "$selected_file" ]]; then
      echo "Running the selected file: $selected_file"
"$snap_dir/usr/bin/python3" "$selected_file"
    else
      echo "Invalid selection."
    fi
  else
    # Only one file found, run it
    single_file=$(echo "$found_files")
    echo "Found one file: $single_file"
    echo "Running the file..."
"$snap_dir/usr/bin/python3" "$single_file"
  fi
else
  echo "No files named '$package' or '$package.py' found."
fi

