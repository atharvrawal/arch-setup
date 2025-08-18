#!/bin/bash

source ~/arch-setup/complete-install/check-status.sh


# Audio Server Setup (Pipewire)
systemctl --user enable pipewire pipewire-pulse wireplumber
check_status "Failed to enable pipewire or pipewire-pulse or wireplumber"
echo "✅ Audio Server (pipewire) Setup Succesful"
echo ""



# Bluetooth Server Setup (Bluez)
sudo systemctl enable --now bluetooth
check_status "Failed to enable Bluez daemon"
echo "✅ Bluetooth Setup Successful"
echo ""



# LY Setup
sudo systemctl enable ly
check_status "Failed to enable ly"
echo "✅ Ly Setup Successful"
echo ""



# Github Setup
git config --global user.email "atharvrawal04@gmail.com"
git config --gllbal user.name "Atharv"
echo "✅ Git Email & Name setup Successful"
echo ""