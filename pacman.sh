#!/bin/bash

DO_REBOOT=true
DO_PREVIEW=true
IGNORE_WRONG_ATTR=false
for ARG in "$@"; do
  case $ARG in
    --no-reboot)
      DO_REBOOT=false
      ;;
    --ignore-wrong-attr)
      IGNORE_WRONG_ATTR=true
      ;;
    --no-preview)
      DO_PREVIEW=false
      ;;
    *)
      if [[ "$IGNORE_WRONG_ATTR" == false ]]; then
          echo ">> Usage: $0 [--no-preview] [--no-reboot] [--ignore-wrong-attr]"
          exit 1
      fi
      ;;
  esac
done


sudo pacman -S sddm --noconfirm
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
