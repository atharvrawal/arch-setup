#!/bin/bash

# ==== Package Groups ====

group_names=(base fileman pipewire bluetooth xorg apps hyprland storage nvidia flatpak_tools)

# parallel array of package lists (same order)
group_pkgs=(
  "curl git nvim tree nmap wget base-devel cmake net-tools network-manager-applet"
  "thunar gvfs gvfs-mtp gvfs-smb"
  "pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber wiremix pavucontrol"
  "bluez bluez-utils bluez-obex"
  "xorg-server xorg-xinit xorg-xrandr libx11 libxinerama libxft webkit2gtk"
  "kitty zsh ly exa rofi btop deluge-gtk"
  "hyprland hyprpaper waybar wofi brightnessctl"
  "ntfs-3g"
  "nvidia-dkms nvidia-utils nvidia-prime libva libva-nvidia-driver mesa"
  "flatpak firefox"
)

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