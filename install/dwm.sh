#!/bin/bash

source ~/arch-setup/install/check-status.sh

# DWM Setup
cd ~/arch-setup/suckless/dmenu
sudo make clean install
check_status "Failed to install DMENU"
cd ~/arch-setup/suckless/dwm
sudo make clean install
check_status "Failed to install DWM"
echo "exec dwm" >> ~/.xinitrc
chmod +x ~/.xinitrc
echo "DWM Setup Successful"
