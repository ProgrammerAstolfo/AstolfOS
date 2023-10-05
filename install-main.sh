#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This installation script must be run as root."
    exit 1
fi


echo "This will overwrite some of the files in your system."
echo "USE WITH CAUTION!"
read -r -p "Do you want to install AstolfOS? (y/n)" install
if [ "$install" != "y" ]; then
    echo "Aborting installation..."
    exit 1
fi

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

if [ -f "/usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/busywidget.svgz" ]; then
    echo "Installing KDE splash 1/2..."
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/kde-splash/busywidget.svgz -o /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/busywidget.svgz
else
    echo "Skipping KDE splash installation 1/2..."
fi

if [ -f "/usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/plasma.svgz" ]; then
    echo "Installing KDE splash 2/2..."    
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/kde-splash/plasma.svgz -o /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/plasma.svgz
else
    echo "Skipping KDE splash installation 2/2..."
fi

if [ -f "/usr/share/pixmaps/ubuntu-logo-dark.png" ]; then
    echo "Overwriting GNOME Ubuntu dark logo..."
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/logo.png -o /usr/share/pixmaps/ubuntu-logo-dark.png    
else
    echo "Skipping GNOME Ubuntu logo overwrite..."
fi

if [ -f "/usr/share/pixmals/ubuntu-logo-icon.png" ]; then
    echo "Overwriting GNOME Ubuntu icon..."
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/logo.png -o /usr/share/pixmaps/ubuntu-logo-icon.png
else
    echo "Skipping GNOME Ubuntu icon overwrite..."
fi

if [ -f "/usr/share/plymouth/ubuntu-logo.png" ]; then
    echo "Overwriting Plymouth Ubuntu logo..."
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/logo.png -o /usr/share/plymouth/ubuntu-logo.png
else
    echo "Skipping Plymouth Ubuntu logo overwrite..."
fi

if [ "$(command -v neofetch)" ]; then
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/ascii-art.txt -o /opt/AstolfOS/ascii-art.txt
    read -r -p "Update neofetch configuration? (y/n)" update
    if [[ "${update}" == "y" ]]; then
        echo "Dropped install-user.sh"
        echo "Please run it as a normal user."
    fi
fi

echo "Finished installation. "
