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
	wofi
	network-manager-applet

	flatpak
	firefox
)

yay_packages=(
	"ttf-firacode-nerd"
	"materia-gtk-theme"
	"papirus-icon-theme"
	#"elecwhat-bin"
	#"brave-bin"
	"bluetuith"
	#"visual-studio-code-bin"
)

flatpacks=(
  #"md.obsidian.Obsidian"
  #"com.discordapp.Discord"
  "org.videolan.VLC"
  #"com.rafaelmardojai.Blanket"
)