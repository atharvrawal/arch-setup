#!/bin/bash

echo "========================================"
echo "Setup is Starting..."
echo "========================================"

source ~/arch-setup/install/check-status.sh

# System Update & Upgrade
bash ~/arch-setup/install/system-update-upgrade.sh
check_status "system-update-upgrade.sh Failed"

# Pacman Packages
bash ~/arch-setup/install/pacman-packages.sh
check_status "pacman-packages.sh Failed"

# Yay
bash ~/arch-setup/install/yay-install.sh
check_status "yay-install.sh Failed"

# Yay Packages
bash ~/arch-setup/install/yay-packages.sh
check_status "yay-packages.sh Failed"

# Audio Server Setup (Pipewire)
systemctl --user enable pipewire pipewire-pulse wireplumber
check_status "Failed to enable pipewire or pipewire-pulse or wireplumber"

# LY Setup
sudo systemctl enable ly
check_status "Failed to enable ly"

# Dark Theme Thunar Setup
bash ~/arch-setup/install/dark-theme-thunar.sh
check_status "darh-theme-thunar.sh Failed"

# DWM Setup
bash ~/arch-setup/install/dwm.sh
check_status "dwm.sh Failed"


