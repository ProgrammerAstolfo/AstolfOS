#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This installation script must be run as root."
    exit 1
fi

echo "Do you want to install AstolfOS? (y/n)"
echo "This will overwrite some of the files in your system."
echo "USE WITH CAUTION!"
read -r install
if [ "$install" != "y" ]; then
    echo "Aborting installation..."
    exit 1
fi

# check if curl is installed
if ! [ -x "$(command -v curl)" ]; then
    echo "curl is not installed. Install?"
    read -r install
    if [ "$install" == "y" ]; then
        sudo apt update
        sudo apt install curl
    else
        echo "Aborting installation..."
        exit 1
    fi
fi

sudo mkdir /opt/AstolfOS
sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/logo.png -o /opt/AstolfOS/logo.png
sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/os-release -o /etc/os-release
sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/kcm-about-distrorc -o /etc/xdg/kcm-about-distrorc

echo "Installed core components"

if [ -d "/usr/share/plasma" ]; then
    echo "Installing KDE splash..."
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/kde-splash/busywidget.svgz -o /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/busywidget.svgz
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/kde-splash/plasma.svgz -o /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/plasma.svgz
else
    echo "KDE is not installed, skipping KDE splash installation..."
fi

echo "Disable splash screen in GRUB? (y/n)"
read -r disable
if [ "$disable" == "y" ]; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT=""/g' /etc/default/grub
    sudo update-grub
fi

if [ "$(command -v neofetch)" ]; then
    echo "Update neofetch configuration? (y/n)"
    read -r update
    if [[ "${update}" == "y" ]]; then
        sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/neofetch.conf -o ~/.config/neofetch/config.conf
        sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/ascii-art.txt -o /opt/AstolfOS/ascii-art.txt
    fi
else
    echo "Neofetch is not installed, configuration will not be updated."
fi

echo "Finished installation. "