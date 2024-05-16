#!/bin/bash

# Check if the package name is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <package>"
    exit 1
fi

package="$1"

# Determine the directory associated with the Snap package
desc_dir="/home/$USER/.local/bin/snapv/desc"

if [ ! -f "$desc_dir"/"$package.txt" ] ; then
 echo "$package not found"
  else
  less "$desc_dir"/"$package.txt"
  echo ""
  cat /home/$USER/.local/bin/snapv/license/$package.txt
  echo ""
  cat /home/$USER/.local/bin/snapv/version/$package.txt
fi 

