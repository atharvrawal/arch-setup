#!/bin/bash

source ~/arch-setup/complete-install/check-status.sh
source ~/arch-setup/complete-install/package-list.sh

echo "========================================"
echo "Setup is Starting..."
echo "========================================"

# System Update & Upgrade
bash ~/arch-setup/complete-install/system-update-upgrade.sh

# Installing All Packages
bash ~/arch-setup/complete-install/package-install.sh

# Service Setup
bash ~/arch-setup/complete-install/service-setup.sh

# Dark Theme Setup
bash ~/arch-setup/complete-install/dark-theme-thunar.sh

# Rust Setup
bash ~/arch-setup/complete-install/rust-install.sh

# Kitty Setup
bash ~/arch-setup/complete-install/kitty-setup.sh

# DWM Setup
bash ~/arch-setup/complete-install/dwm-setup.sh

# Hyprland Setup
bash ~/arch-setup/complete-install/hyprland-setup.sh

# QEMU Setup
bash ~/arch-setup/complete-install/qemu-setup.sh



