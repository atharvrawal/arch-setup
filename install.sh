#!/bin/bash

echo "========================================"
echo "Setup is Starting..."
echo "========================================"


# Function to check the exit status of the last command
check_status(){
	if [ $? -ne 0 ]; then
		echo "Error: $1"
		exit 1
	fi
}


echo "Updating & Upgrading Arch..."
sudo pacman -Syy --noconfirm >/dev/null
check_status "Failed to update the package database."
sudo pacman -Syu --noconfirm >/dev/null
check_status "Failed to upgrade the package database."
echo "Successfully Updated & Upgraded"
echo ""


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
	obs-studio
	flatpak
    xorg-server
    xorg-xinit
    xorg-xrandr
    libx11
    libxinerama
    libxft
    webkit2gtk
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

systemctl --user enable pipewire pipewire-pulse wireplumber
check_status "Failed to enable pipewire or pipewire-pulse or wireplumber"

cd suckless
cd st
sudo make clean install
cd ..
cd dmenu
sudo make clean install
cd ..




echo "Installing Yay..."
git clone https://aur.archlinux.org/yay.git >/dev/null 2>&1
check_status "Failed to clone yay repository."
cd yay || { echo "Failed to change directory to yay."; exit 1; }
makepkg -si --noconfirm >/dev/null 2>&1
check_status "Failed to build and install yay."
yay --version
cd ..
sudo rm -rf yay >/dev/null
check_status "Failed to remove the yay package"
echo "Above Version is yay version and is Successfully Installed"
echo ""


yay_packages=(
	"elecwhat-bin"
	# "brave-bin"
	"visual-studio-code-bin"
)


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




echo "Installing flatpacks..."
flatpacks=(
  "md.obsidian.Obsidian"
  "com.discordapp.Discord"
  "com.spotify.Client"
  "com.obsproject.Studio"
  "org.kde.kate"
  "org.videolan.VLC"
  "com.rafaelmardojai.Blanket"
)

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
