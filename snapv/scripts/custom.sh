#!/bin/bash

# Prompt user to choose snap-package folder
echo "Choose snap-package folder:"
ls /home/$USER/.local/bin/snapv/snaps/

# Read the package name from the user
read -p "Enter the package name: " package

# Construct the path to the snap-package folder
snap="/home/$USER/.local/bin/snapv/snaps/$package"
echo "$snap"

# Change to the snap-package directory or exit with status 2 if it fails
cd "$snap" || { echo "Failed to change directory to $snap"; exit 2; }

# List the contents of the snap-package directory
ls 
echo ""
echo ""

# Prompt the user to enter the command to start the snap script
read -p "Type command to start snap script and hit enter: " COMMAND
echo "$COMMAND"

# Construct the LD_LIBRARY_PATH
LD_LIBRARY_PATH="/home/$USER/.local/bin/snapv/snaps/$package/lib"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/$USER/.local/bin/snapv/snaps/$package/usr/lib/x86_64-linux-gnu"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/$USER/.local/bin/snapv/snaps/$package/lib/x86_64-linux-gnu"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/$USER/.local/bin/snapv/fake_lib64"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/$USER/.local/bin/snapv/snaps/$package/usr/lib/x86_64-linux-gnu/pulseaudio"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/$USER/.local/bin/snapv/snaps/$package/usr/lib/x86_64-linux-gnu/gnome-software"

QT_QPA_PLATFORM_PLUGIN_PATH="/home/$USER/.local/bin/snapv/snaps/$package/usr/lib/x86_64-linux-gnu/qt5/plugins"
ETC_PATH="/home/$USER/.local/bin/snapv/snaps/$package/etc"

export LD_LIBRARY_PATH QT_QPA_PLATFORM_PLUGIN_PATH ETC_PATH

export_env_vars() {
    # Iterate over all directories in the Snap package directory
    for dir in $(find "$snap" -type d); do
        # Extract the directory name
        dir_name=$(basename "$dir")
        # Convert the directory name to uppercase and replace non-alphanumeric characters with underscores
        export_var=$(echo "${dir_name^^}" | tr -c '[:alnum:]' '_')_DIR
        # Export the environment variable
        export "$export_var=$dir"
        echo "Exporting variable: $export_var=$dir"
    done

    # Export LD_LIBRARY_PATH for common lib directories
    if [ -d "$snap/lib" ]; then
        export LD_LIBRARY_PATH="$snap/lib:$LD_LIBRARY_PATH"
        echo "Exporting variable: LD_LIBRARY_PATH=$snap/lib:$LD_LIBRARY_PATH"
    fi
    if [ -d "$snap/usr/lib" ]; then
        export LD_LIBRARY_PATH="$snap/usr/lib:$LD_LIBRARY_PATH"
        echo "Exporting variable: LD_LIBRARY_PATH=$snap/usr/lib:$LD_LIBRARY_PATH"
    fi

    # Export PATH for common bin directories
    if [ -d "$snap/bin" ]; then
        export PATH="$snap/bin:$PATH"
        echo "Exporting variable: PATH=$snap/bin:$PATH"
    fi
    if [ -d "$snap/usr/bin" ]; then
        export PATH="$snap/usr/bin:$PATH"
        echo "Exporting variable: PATH=$snap/usr/bin:$PATH"
    fi

    # Export PYTHONPATH for common python directories
    if [ -d "$snap/lib/$pyvers/site-packages" ]; then
        export PYTHONPATH="$snap/lib/$pyvers/site-packages:$PYTHONPATH"
        echo "Exporting variable: PYTHONPATH=$snap/lib/$pyvers/site-packages:$PYTHONPATH"
    fi
    if [ -d "$snap/usr/lib/$pyvers/site-packages" ]; then
        export PYTHONPATH="$snap/usr/lib/$pyvers/site-packages:$PYTHONPATH"
        echo "Exporting variable: PYTHONPATH=$snap/usr/lib/$pyvers/site-packages:$PYTHONPATH"
    fi

    # Export QT_PLUGIN_PATH for common Qt directories
    if [ -d "$snap/lib/qt5/plugins" ]; then
        export QT_PLUGIN_PATH="$snap/lib/qt5/plugins:$QT_PLUGIN_PATH"
        echo "Exporting variable: QT_PLUGIN_PATH=$snap/lib/qt5/plugins:$QT_PLUGIN_PATH"
    fi
    if [ -d "$snap/usr/lib/qt5/plugins" ]; then
        export QT_PLUGIN_PATH="$snap/usr/lib/qt5/plugins:$QT_PLUGIN_PATH"
        echo "Exporting variable: QT_PLUGIN_PATH=$snap/usr/lib/qt5/plugins:$QT_PLUGIN_PATH"
    fi

    # Export XDG_DATA_DIRS for common data directories
    if [ -d "$snap/share" ]; then
        export XDG_DATA_DIRS="$snap/share:$XDG_DATA_DIRS"
        echo "Exporting variable: XDG_DATA_DIRS=$snap/share:$XDG_DATA_DIRS"
    fi
    if [ -d "$snap/usr/share" ]; then
        export XDG_DATA_DIRS="$snap/usr/share:$XDG_DATA_DIRS"
        echo "Exporting variable: XDG_DATA_DIRS=$snap/usr/share:$XDG_DATA_DIRS"
    fi

    # Export FONTCONFIG_PATH for additional font directories
    if [ -d "$snap/etc/fonts" ]; then
        export FONTCONFIG_PATH="$snap/etc/fonts:$FONTCONFIG_PATH"
        echo "Exporting variable: FONTCONFIG_PATH=$snap/etc/fonts:$FONTCONFIG_PATH"
    fi

    if [ -d "$snap/usr/share/fonts" ]; then
        export FONTCONFIG_PATH="$snap/usr/share/fonts:$FONTCONFIG_PATH"
        echo "Exporting variable: FONTCONFIG_PATH=$snap/usr/share/fonts:$FONTCONFIG_PATH"
    fi

    # Export FONTCONFIG_FILE to point to the Fontconfig configuration file
    if [ -f "$snap/etc/fonts/fonts.conf" ]; then
        export FONTCONFIG_FILE="$snap/etc/fonts/fonts.conf"
        echo "Exporting variable: FONTCONFIG_FILE=$snap/etc/fonts/fonts.conf"
    fi

    # Export PERLLIB for common Perl library directories
    if [ -d "$snap/lib/perl5" ]; then
        export PERLLIB="$snap/lib/perl5:$PERLLIB"
        echo "Exporting variable: PERLLIB=$snap/lib/perl5:$PERLLIB"
    fi
    if [ -d "$snap/usr/lib/perl5" ]; then
        export PERLLIB="$snap/usr/lib/perl5:$PERLLIB"
        echo "Exporting variable: PERLLIB=$snap/usr/lib/perl5:$PERLLIB"
    fi

    # Export MANPATH for common man directories
    if [ -d "$snap/share/man" ]; then
        export MANPATH="$snap/share/man:$MANPATH"
        echo "Exporting variable: MANPATH=$snap/share/man:$MANPATH"
    fi
    if [ -d "$snap/usr/share/man" ]; then
        export MANPATH="$snap/usr/share/man:$MANPATH"
        echo "Exporting variable: MANPATH=$snap/usr/share/man:$MANPATH"
    fi

    # Export INFOPATH for common info directories
    if [ -d "$snap/share/info" ]; then
        export INFOPATH="$snap/share/info:$INFOPATH"
        echo "Exporting variable: INFOPATH=$snap/share/info:$INFOPATH"
    fi
    if [ -d "$snap/usr/share/info" ]; then
        export INFOPATH="$snap/usr/share/info:$INFOPATH"
        echo "Exporting variable: INFOPATH=$snap/usr/share/info:$INFOPATH"
    fi

    # Export PKG_CONFIG_PATH for common pkg-config directories
    if [ -d "$snap/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$snap/lib/pkgconfig:$PKG_CONFIG_PATH"
        echo "Exporting variable: PKG_CONFIG_PATH=$snap/lib/pkgconfig:$PKG_CONFIG_PATH"
    fi
    if [ -d "$snap/usr/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$snap/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
        echo "Exporting variable: PKG_CONFIG_PATH=$snap/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
    fi
    if [ -d "$snap/share/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$snap/share/pkgconfig:$PKG_CONFIG_PATH"
        echo "Exporting variable: PKG_CONFIG_PATH=$snap/share/pkgconfig:$PKG_CONFIG_PATH"
    fi
    if [ -d "$snap/usr/share/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$snap/usr/share/pkgconfig:$PKG_CONFIG_PATH"
        echo "Exporting variable: PKG_CONFIG_PATH=$snap/usr/share/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # Export GTK paths
    if [ -d "$snap/lib/gtk-2.0" ]; then
        export GTK_PATH="$snap/lib/gtk-2.0:$GTK_PATH"
        echo "Exporting variable: GTK_PATH=$snap/lib/gtk-2.0:$GTK_PATH"
    fi
    if [ -d "$snap/usr/lib/gtk-2.0" ]; then
        export GTK_PATH="$snap/usr/lib/gtk-2.0:$GTK_PATH"
        echo "Exporting variable: GTK_PATH=$snap/usr/lib/gtk-2.0:$GTK_PATH"
    fi
    if [ -d "$snap/lib/gtk-3.0" ]; then
        export GTK_PATH="$snap/lib/gtk-3.0:$GTK_PATH"
        echo "Exporting variable: GTK_PATH=$snap/lib/gtk-3.0:$GTK_PATH"
    fi
    if [ -d "$snap/usr/lib/gtk-3.0" ]; then
        export GTK_PATH="$snap/usr/lib/gtk-3.0:$GTK_PATH"
        echo "Exporting variable: GTK_PATH=$snap/usr/lib/gtk-3.0:$GTK_PATH"
    fi
    if [ -d "$snap/etc/gtk-2.0" ]; then
        export GTK2_RC_FILES="$snap/etc/gtk-2.0:$GTK2_RC_FILES"
        echo "Exporting variable: GTK2_RC_FILES=$snap/etc/gtk-2.0:$GTK2_RC_FILES"
    fi
    if [ -d "$snap/etc/gtk-3.0" ]; then
        export GTK3_MODULES="$snap/etc/gtk-3.0:$GTK3_MODULES"
        echo "Exporting variable: GTK3_MODULES=$snap/etc/gtk-3.0:$GTK3_MODULES"
    fi
}

# Call the function to export environment variables
export_env_vars

# Find the Python version directory
python_version1=$(find ./ -type d -name site-packages -exec dirname {} + | head -n 1)
echo "$python_version1" > "$snap/print_python.txt"
sed -i '1!d' "$snap/print_python.txt"
sed -i 's|.*/\(.*\)|\1|' "$snap/print_python.txt"

# Read the Python version from the file
pyvers=$(cat "$snap/print_python.txt")
echo "$pyvers"

# Run the command provided by the user
LD_LIBRARY_PATH="$LD_LIBRARY_PATH" QT_QPA_PLATFORM_PLUGIN_PATH="$QT_QPA_PLATFORM_PLUGIN_PATH" ETC_PATH="$ETC_PATH" source "$COMMAND"
