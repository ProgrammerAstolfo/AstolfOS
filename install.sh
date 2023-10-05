#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This installation script must be run as root."
    exit 1
fi


echo "This will overwrite some of the files in your system."
echo "USE WITH CAUTION!"
echo -n "Do you want to install AstolfOS? (y/n)"
read -r install
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

if [ -d "/usr/share/plasma" ]; then
    echo "Installing KDE splash..."
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/kde-splash/busywidget.svgz -o /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/busywidget.svgz
    sudo curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/kde-splash/plasma.svgz -o /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/plasma.svgz
else
    echo "KDE is not installed, skipping KDE splash installation..."
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

echo "Disable splash screen in GRUB? (y/n)"
read -r disable
if [ "$disable" == "y" ]; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet nosplash"/g' /etc/default/grub
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

read -r -p "Update bashrc to change the prompt? (y/n)" update
if [[ "${update}" == "y" ]]; then
# download and append
    curl https://raw.githubusercontent.com/ProgrammerAstolfo/AstolfOS/master/files/bashrc.sh -o ~/.bashrc.append
    cat ~/.bashrc.append >> ~/.bashrc
    rm ~/.bashrc.append
fi

echo "Finished installation. "
