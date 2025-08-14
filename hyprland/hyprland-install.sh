#!/bin/bash

source ~/arch-setup/post-install/check-status.sh

yay -S --needed --noconfirm hyprland-git >/dev/null 2>&1
check_status "Failed to install hyprland-git"

# Symlinks
# hyprland.conf 
mkdir -p ~/.config/hypr
ln -s ~/arch-setup/hyprland/hyprland.conf ~/.config/hypr/hyprland.conf

# hyprpaper
ln -s ~/arch-setup/hyprland/hyprpaper/hyprpaper.conf ~/.config/hypr/hyprpaper.conf
mkdir -p ~/Pictures/Screenshots
cp ~/arch-setup/hyprland/hyprpaper/wallpaper.jpg ~/Pictures

# waybar
mkdir -p ~/.config/waybar
ln -s ~/arch-setup/hyprland/waybar/config.jsonc ~/.config/waybar/config.jsonc
ln -s ~/arch-setup/hyprland/waybar/style.css ~/.config/waybar/style.css
