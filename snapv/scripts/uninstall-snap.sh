#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'


if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}snapV should not be build, install, uninstall, run, etc... with root privileges.${NC} Exiting."
    exit 1
fi

cd $(dirname $0) ; CWD=$(pwd)

set -e


ME=$(whoami)
HOME=$HOME

if [ "$HOME" == /home/"$ME" ] ; then
    cd ~/.local/bin
    rm snap || exit 8
    rm -fr snapv || exit 8
  else
    echo -e "Something going wrong...$HOME is not your ~/$ME"
    echo "You must remove snap manually by deleting files"
    exit 99
fi 

echo ""
echo "RIP snapV...deleted from system"

 
