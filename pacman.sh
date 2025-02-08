#!/bin/bash

sudo pacman -S sddm
sudo systemctl disable gdm.service
sudo systemctl enable sddm.service
sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

read -p "Do you wish to reboot now? (y/n): " re
if [[ "$re" == "y" ]]; then
    sudo reboot now
fi