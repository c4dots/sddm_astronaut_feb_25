#!/bin/bash

DO_REBOOT=true
DO_PREVIEW=true
for ARG in "$@"; do
  case $ARG in
    --help)
      echo ">> Usage: $0 [--no-preview] [--no-reboot]"
      exit 1
      ;;
    --no-reboot)
      DO_REBOOT=false
      ;;
    --no-preview)
      DO_PREVIEW=false
      ;;
  esac
done

install_package() {
    local package="$1"

    if command -v "$package" &>/dev/null || 
       (command -v dpkg &>/dev/null && dpkg -l | grep -q "^ii  $package ") || 
       (command -v rpm &>/dev/null && rpm -q "$package" &>/dev/null) || 
       (command -v pacman &>/dev/null && pacman -Q "$package" &>/dev/null); then
        echo " | $package is already installed."
        return 0
    fi

    echo " | Installing $package..."

    if command -v apt &>/dev/null; then
        sudo apt install -y "$package" &> /dev/null
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y "$package" &> /dev/null
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm "$package" &> /dev/null
    elif command -v yay &>/dev/null; then
        yay -S --noconfirm "$package" &> /dev/null
    else
        echo "No supported package manager found. Please install '$package' manually."
        return 2
    fi
}

install_package sddm
sudo systemctl disable gdm.service
sudo systemctl enable sddm.service
sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

sudo rm -R ~/sddm-astronaut-theme*


if [[ "$DO_PREVIEW" == true ]]; then
    read -p "Do you wish to see a preview? (y/n): " re
    if [[ "$re" == "y" ]]; then
        sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme/
    fi
fi

if [[ "$DO_REBOOT" == true ]]; then
    read -p "Do you wish to reboot now? (y/n): " re
    if [[ "$re" == "y" ]]; then
        sudo reboot now
    fi
fi
