#!/bin/bash

pacman_packages=(
	curl
	git
	nvim
	tree
	nmap
	wget
	base-devel
	cmake
	net-tools
	network-manager-applet

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
	deluge-gtk

	hyprpaper
	waybar
	wofi
	ntfs-3g
	brightnessctl
	
	nvidia-dkms
	nvidia-utils
	nvidia-prime
	libva
	libva-nvidia-driver
	mesa

	flatpak
	firefox
)

yay_packages=(
	"ttf-firacode-nerd"
	"materia-gtk-theme"
	"papirus-icon-theme"
	"elecwhat-bin"
	"brave-bin"
	"bluetuith"
	"visual-studio-code-bin"
	"powershell-bin"
)

flatpacks=(
  "md.obsidian.Obsidian"
  "com.discordapp.Discord"
  "org.videolan.VLC"
  "com.rafaelmardojai.Blanket"
)