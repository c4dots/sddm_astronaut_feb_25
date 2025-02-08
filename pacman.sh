#!/bin/bash

DO_REBOOT=true
for ARG in "$@"; do
  case $ARG in
    --no-reboot)
      DO_REBOOT=false
      ;;
    *)
      echo ">> Usage: $0 [--no-reboot]"
      exit 1
      ;;
  esac
done


sudo pacman -S sddm --noconfirm
sudo systemctl disable gdm.service
sudo systemctl enable sddm.service
sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

sudo rm -R ~/sddm-astronaut-theme*

if [[ "$DO_REBOOT" == true ]]; then
    read -p "Do you wish to reboot now? (y/n): " re
    if [[ "$re" == "y" ]]; then
        sudo reboot now
    fi
fi
