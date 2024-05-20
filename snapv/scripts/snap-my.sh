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
  echo "$package-desc file"
  echo "======="
  cat "$desc_dir"/"$package.txt"
  wait
  echo ""
  echo "========"
  echo "LICENSE"
  cat /home/$USER/.local/bin/snapv/license/$package.txt
  wait
  echo ""
  echo "======="
  echo "VERSION_REVISION"
  cat /home/$USER/.local/bin/snapv/version/$package.txt
fi 

