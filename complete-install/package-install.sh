#!/bin/bash
source ~/arch-setup/complete-install/check-status.sh
source ~/arch-setup/complete-install/package-list.sh

echo "Installing pacman packages..."
for group in "${!pacman_names[@]}"; do
    echo ""
    echo "=== Package group: $group ==="
    echo "${group_pkgs[$group]}"
    
    read -p "Do you want to install the '$group' package group? (y/n): " choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        echo "➡ Installing group: $group"
        for pkg in ${group_pkgs[$group]}; do
            sudo pacman -S --needed --noconfirm "$pkg" >/dev/null 2>&1
            check_status "Failed to install $pkg"
            echo "  ✔ $pkg installed"
        done
    else
        echo "❌ Skipping $group group"
    fi
done
echo "✅ All selected pacman groups installed successfully"
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
