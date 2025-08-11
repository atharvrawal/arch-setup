#!/bin/bash

source ~/arch-setup/install/check-status.sh

yay_packages=(
	"ttf-firacode-nerd"
	"materia-gtk-theme"
	"papirus-icon-theme"
)
echo "Installing Yay Packages..."
j=0
total=${#yay_packages[@]}
while [ $j -lt $total ]; do
  pkg=${yay_packages[$j]}
  yay -S --needed --noconfirm "$pkg" >/dev/null 2>&1
  check_status "Failed to install $pkg"
  echo "✅ $pkg installed successfully"
  ((j++))
done
echo "All yay packages installed succesfully"
echo ""