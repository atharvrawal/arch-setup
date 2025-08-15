#!/bin/bash

source ~/arch-setup/install/check-status.sh

echo "Installing pacman packages..."
i=0
total=${#pacman_packages[@]}
while [ $i -lt $total ]; do
  pkg=${pacman_packages[$i]}
  sudo pacman -S --needed --noconfirm "$pkg" >/dev/null 2>&1
  check_status "Failed to install $pkg"
  echo "✅ $pkg installed successfully"
  ((i++))
done
echo "All pacman packages installed successfully"
echo ""