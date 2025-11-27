#!/bin/bash

source ~/arch-setup/complete-install/check-status.sh
source ~/arch-setup/complete-install/package-list.sh

echo "========================================"
echo "Setup is Starting..."
echo "========================================"

# System Update & Upgrade
bash ~/arch-setup/complete-install/system-update-upgrade.sh

# Installing Pacman Packages
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

# Installing Yay
bash ~/arch-setup/complete-install/yay-install.sh

# Installing Yay Packages
read -p "Do you want to install Yay Packages? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
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
else
    echo "Skipping Yay Packages installation."
fi

# Flatpak Setup
read -p "Do you want to install Flatpak? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "Installing Flatpak Packages..."
    k=0 
    total=${#flatpacks[@]}
    while [ $k -lt $total ]; do
      pkg=${flatpacks[$k]}
      flatpak install -y --noninteractive flathub "$pkg" >/dev/null 2>&1
      check_status "Failed to install $pkg"
      echo "✅ $pkg installed successfully"
      ((k++))
    done
    echo "All flatpak packages installed successfully!"
    echo ""
else
    echo "Skipping Flatpak installation."
fi

# Service Setup
bash ~/arch-setup/complete-install/service-setup.sh

# Pipewire Setup
bash ~/arch-setup/complete-install/pipewire-setup.sh

# Bluetooth Setup
bash ~/arch-setup/complete-install/bluetooth-setup.sh

# Dark Theme Setup
bash ~/arch-setup/complete-install/dark-theme-thunar.sh

# Rust Setup
read -p "Do you want to install Rust? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    bash ~/arch-setup/complete-install/rust-install.sh
else
    echo "Skipping Rust installation."
fi

# Kitty Setup
read -p "Do you want to install Kitty? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    bash ~/arch-setup/complete-install/kitty-setup.sh
else
    echo "Skipping Kitty installation."
fi

# DWM Setup
read -p "Do you want to install DWM? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    bash ~/arch-setup/complete-install/dwm-setup.sh
else
    echo "Skipping DWM installation."
fi

# Hyprland Setup
read -p "Do you want to install Hyprland? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    bash ~/arch-setup/complete-install/hyprland-install.sh
else
    echo "Skipping Hyprland installation."
fi

# QEMU Setup
read -p "Do you want to install QEMU? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    bash ~/arch-setup/complete-install/qemu-setup.sh
else
    echo "Skipping QEMU installation."
fi




