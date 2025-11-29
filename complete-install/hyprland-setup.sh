#!/bin/bash
read -p "Do you want to use my Hyprland conf ? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    source ~/arch-setup/complete-install/check-status.sh
    # Symlinks
    # hyprland.conf 
    sudo rm -rf ~/.config/hypr
    mkdir -p ~/.config/hypr
    ln -s ~/arch-setup/hyprland/hyprland.conf ~/.config/hypr/hyprland.conf >/dev/null 2>&1
    echo "hyprland.conf symlink successful setup"

    # hyprpaper
    ln -s ~/arch-setup/hyprland/hyprpaper/hyprpaper.conf ~/.config/hypr/hyprpaper.conf >/dev/null 2>&1
    mkdir -p ~/Pictures/Screenshots
    cp ~/arch-setup/hyprland/hyprpaper/wallpaper.jpg ~/Pictures
    echo "hyprpaper.conf symlink successfully setup"

    # waybar
    sudo rm -rf ~/.config/waybar
    mkdir -p ~/.config/waybar
    ln -s ~/arch-setup/hyprland/waybar/config.jsonc ~/.config/waybar/config.jsonc >/dev/null 2>&1
    ln -s ~/arch-setup/hyprland/waybar/style.css ~/.config/waybar/style.css >/dev/null 2>&1
    echo "waybar symlink successfully setup"
else
    echo "Skipping Hyprland installation."
fi