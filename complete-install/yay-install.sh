#!/bin/bash

source ~/arch-setup/install/check-status.sh

if command -v yay >/dev/null 2>&1; then
    echo "Yay is already installed. Skipping installation."
    yay --version
    echo ""
else
  echo "Installing Yay..."
  git clone https://aur.archlinux.org/yay.git >/dev/null 2>&1
  check_status "Failed to clone yay repository."
  cd yay || { echo "Failed to change directory to yay."; exit 1; }
  makepkg -si --noconfirm >/dev/null 2>&1
  check_status "Failed to build and install yay."
  yay --version
  cd ..
  sudo rm -rf yay >/dev/null
  check_status "Failed to remove the yay package"
  echo "Above Version is yay version and is Successfully Installed"
  echo ""
fi