#!/bin/bash

# Check if the package name is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <package>"
    exit 1
fi

package="$1"

if [ "$package" = custom  ]; then
 echo "WRONG COMMAND"
 echo "JUST TYPE: snap custom"
 sleep 2
 echo ""
  exit 2
fi


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
#cd "$snap_dir" || exit 6

# Find the binary associated with the Snap package
binary=$(find "$snap_dir" -type f -executable -name "$package")
# Check if any files were found
if [[ -n "$binary" ]]; then
  # Count the number of found files
  file_count=$(echo "$binary" | wc -l)
  
  if [[ "$file_count" -gt 1 ]]; then
    echo "Found multiple files:"
    echo "$binary" | nl -w 2 -s '. ' # Print files with numbers for selection

    # Ask user to choose a file
    echo "Please enter the number of the file you want to run:"
    read -r choice

    # Get the selected file path
    selected_file=$(echo "$binary" | sed -n "${choice}p")
fi
fi

# Check if the binary exists
if [ -z "$binary" ]; then
   bash "$package"
else
  source /home/$USER/.local/bin/snapv/scripts/try-python.sh $package & 
  fi
  
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
    if [ -d "$snap_dir/lib/i386-linux-gnu" ]; then
        export LD_LIBRARY_PATH="$snap_dir/lib/i386-linux-gnu:$LD_LIBRARY_PATH"
        echo "Exporting variable: LD_LIBRARY_PATH=$snap_dir/lib/i386-linux-gnu:$LD_LIBRARY_PATH"
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


echo "$selected_file"
parent_path=$(dirname "$selected_file")
cd "$parent_path" || { echo "Failed to change directory to $parent_path"; exit 1; }

if [ "$UID" -eq 1000 ]; then
    echo "UID is 1000. Proceed with running the app."
   echo "trying trying exec_cmd" 
bash "$package"
else
env -u SESSION_MANAGER  "$package" & exec "$package" 
echo "env did the job"
fi


