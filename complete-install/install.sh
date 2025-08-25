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



# Installing Flatpaks
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


# Service Setup
bash ~/arch-setup/complete-install/service-setup.sh



# Dark Theme Setup
bash ~/arch-setup/complete-install/dark-theme-thunar.sh



# Rust Install
bash ~/arch-setup/complete-install/rust-install.sh



# Kitty Setup
bash ~/arch-setup/complete-install/kitty-setup.sh



# DWM Setup
cd ~/arch-setup/suckless/dmenu
sudo make clean install >/dev/null 2>&1
check_status "Failed to install DMENU"
cd ~/arch-setup/suckless/dwm
sudo make clean install >/dev/null 2>&1
check_status "Failed to install DWM"
echo "exec dwm" >> ~/.xinitrc
chmod +x ~/.xinitrc
echo "✅ DWM Setup Successful"



# Hyprland Setup
bash ~/arch-setup/complete-install/hyprland-install.sh





