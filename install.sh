#!/bin/bash
if ! [ "$(command -v curl)" ]; then
    echo "Curl is not installed. Can't continue."
    exit 1
fi

if (( $(id -u) == 0 )); then
    echo "Run this script as a non-root user. This script will ask for root permissions when needed."
    exit 1
fi


curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/install-main.sh -o ./install-main.sh
sudo chmod +x ./install-main.sh
sudo ./install-main.sh

echo "Installing stuff for non-root user..."

if [ "$(command -v neofetch)" ]; then
    echo "Update neofetch configuration? (y/n)"
    read -r update
    if [[ "${update}" == "y" ]]; then
        sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/config.conf -o ~/.config/neofetch/config.conf
    fi
else
    echo "Neofetch is not installed, configuration will not be updated."
fi

read -r -p "Update bashrc to change the prompt? (y/n)" update
if [[ "${update}" == "y" ]]; then
    curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/bashrc.sh -o ~/.bashrc.append
    cat ~/.bashrc.append >> ~/.bashrc
    rm ~/.bashrc.append
fi