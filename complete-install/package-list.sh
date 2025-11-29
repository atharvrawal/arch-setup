#!/bin/bash

# ==== Package Groups ====

declare -A pacman_groupsr=(
  [base]="curl git nvim tree nmap wget base-devel cmake net-tools network-manager-applet"
  [fileman]="thunar gvfs gvfs-mtp gvfs-smb"
  [pipewire]="pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber wiremix pavucontrol"
  [bluetooth]="bluez bluez-utils bluez-obex"
  [xorg]="xorg-server xorg-xinit xorg-xrandr libx11 libxinerama libxft webkit2gtk"
  [apps]="kitty zsh ly exa rofi btop deluge-gtk"
  [hyprland]="hyprland hyprpaper waybar wofi brightnessctl"
  [storage]="ntfs-3g"
  [nvidia]="nvidia-dkms nvidia-utils nvidia-prime libva libva-nvidia-driver mesa"
  [flatpak_tools]="flatpak firefox"
)
pacman_order=( base fileman pipewire bluetooth xorg apps hyprland storage nvidia flatpak_tools )

yay_packages=(
	"ttf-firacode-nerd"
	"materia-gtk-theme"
	"papirus-icon-theme"
	"bluetuith"
	"visual-studio-code-bin"
	"powershell-bin"
)

flatpacks=(
  "com.discordapp.Discord"
  "org.videolan.VLC"
  "com.rafaelmardojai.Blanket"
)