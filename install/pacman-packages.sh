#!/bin/bash

source ~/arch-setup/install/check-status.sh

echo "Installing pacman packages..."
pacman_packages=(
	curl
	git
	nvim
	tree
	nmap
	wget
	base-devel
	cmake

 	pipewire 
  	pipewire-audio 
  	pipewire-alsa 
  	pipewire-pulse 
  	pipewire-jack
  	wireplumber
	wiremix
	pavucontrol

	thunar 
	gvfs 
	gvfs-mtp 
	gvfs-smb

	xorg-server
	xorg-xinit
	xorg-xrandr
	libx11
	libxinerama
	libxft
	webkit2gtk

	kitty
	zsh
	ly
	exa
	rofi
	btop
	exa

	bluez
    bluez-utils
    bluez-obex

	hyprpaper
	waybar

	flatpak
	firefox
)
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