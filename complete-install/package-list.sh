#!/bin/bash

# ==== Package Groups ====

declare -A pacman_groups

pacman_groups=(
  [base]="curl git nvim tree nmap wget base-devel cmake net-tools network-manager-applet"
  [fileman]="thunar gvfs gvfs-mtp gvfs-smb"
  [xorg]="xorg-server xorg-xinit xorg-xrandr libx11 libxinerama libxft webkit2gtk"
  [apps]="kitty zsh ly exa rofi btop deluge-gtk"
  [wayland]="hyprpaper waybar wofi brightnessctl"
  [storage]="ntfs-3g"
  [nvidia]="nvidia-dkms nvidia-utils nvidia-prime libva libva-nvidia-driver mesa"
  [flatpak_tools]="flatpak firefox"
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